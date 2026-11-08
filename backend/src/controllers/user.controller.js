
import { asyncHandler } from "../utils/async_handler.js";
import { ApiError } from "../utils/api_error.js";
import { ApiResponse } from "../utils/api_response.js";
import { User } from "../models/user.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";

import jwt from "jsonwebtoken";
import mongoose from "mongoose";

// Shared cookie options. `secure` is only forced in production so cookies
// still work on http://localhost during development.
const cookieOptions = {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
};

const generateAccessAndRefreshTokens = async (userId) => {
    try {
        const user = await User.findById(userId);
        if (!user) {
            throw new ApiError(404, "user not found");
        }

        const accessToken = user.generateAccessToken();
        const refreshToken = user.generateRefreshToken();

        user.refreshToken = refreshToken;
        await user.save({ validateBeforeSave: false });

        return { accessToken, refreshToken };
    } catch (error) {
        if (error instanceof ApiError) throw error;
        throw new ApiError(
            500,
            "something went wrong while generating refresh and access tokens"
        );
    }
};

const registerUser = asyncHandler(async (req, res) => {
    // Steps:
    // get user details from frontend
    // validate: no empty fields
    // check if user already exists (username, email)
    // check for avatar image, upload to cloudinary
    // create user in db
    // remove password and refresh token from response
    // return response

    const { fullName, email, userName, password } = req.body || {};

    // Catches both missing (undefined) and empty/whitespace-only fields
    if (
        [fullName, email, userName, password].some(
            (field) => typeof field !== "string" || field.trim() === ""
        )
    ) {
        throw new ApiError(400, "all fields are required");
    }

    const existedUser = await User.findOne({
        $or: [
            { userName: userName.toLowerCase() },
            { email: email.toLowerCase() },
        ],
    });

    if (existedUser) {
        throw new ApiError(409, "user with this username or email already exists");
    }

    // multer puts the uploaded files on req.files
    const avatarLocalPath = req.files?.avatar?.[0]?.path;
    const coverImageLocalPath = req.files?.coverImage?.[0]?.path;

    if (!avatarLocalPath) {
        throw new ApiError(400, "avatar image is required");
    }

    const avatar = await uploadOnCloudinary(avatarLocalPath);
    const coverImage = coverImageLocalPath
        ? await uploadOnCloudinary(coverImageLocalPath)
        : null;

    if (!avatar) {
        throw new ApiError(400, "avatar upload failed, please try again");
    }

    const user = await User.create({
        fullName: fullName.trim(),
        avatar: avatar.url,
        coverImage: coverImage?.url || "",
        email,
        password,
        userName: userName.toLowerCase(),
    });

    // password and refreshToken are excluded from the response
    const createdUser = await User.findById(user._id).select(
        "-password -refreshToken"
    );

    if (!createdUser) {
        throw new ApiError(500, "something went wrong while registering the user");
    }

    return res
        .status(201)
        .json(new ApiResponse(201, createdUser, "user registered successfully"));
});

const loginUser = asyncHandler(async (req, res) => {
    // Steps:
    // get data from req.body
    // username or email required
    // find user
    // check password
    // generate access and refresh tokens
    // send cookies

    const { email, userName, password } = req.body || {};

    if (!(email || userName)) {
        throw new ApiError(400, "username or email is required");
    }

    if (!password) {
        throw new ApiError(400, "password is required");
    }

    const user = await User.findOne({
        $or: [
            { userName: userName?.toLowerCase() },
            { email: email?.toLowerCase() },
        ],
    });

    if (!user) {
        throw new ApiError(404, "user does not exist");
    }

    const isPasswordValid = await user.isPasswordCorrect(password);

    if (!isPasswordValid) {
        throw new ApiError(401, "incorrect password");
    }

    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(
        user._id
    );

    const loggedInUser = await User.findById(user._id).select(
        "-password -refreshToken"
    );

    return res
        .status(200)
        .cookie("accessToken", accessToken, cookieOptions)
        .cookie("refreshToken", refreshToken, cookieOptions)
        .json(
            new ApiResponse(
                200,
                { user: loggedInUser, accessToken, refreshToken },
                "user logged in successfully"
            )
        );
});

const logoutUser = asyncHandler(async (req, res) => {
    await User.findByIdAndUpdate(
        req.user._id,
        { $unset: { refreshToken: 1 } },
        { new: true }
    );

    return res
        .status(200)
        .clearCookie("accessToken", cookieOptions)
        .clearCookie("refreshToken", cookieOptions)
        .json(new ApiResponse(200, {}, "user logged out successfully"));
});

const refreshAccessToken = asyncHandler(async (req, res) => {
    const incomingRefreshToken = req.cookies?.refreshToken || req.body?.refreshToken;

    if (!incomingRefreshToken) {
        throw new ApiError(401, "unauthorized request");
    }

    let decodedToken;
    try {
        decodedToken = jwt.verify(
            incomingRefreshToken,
            process.env.REFRESH_TOKEN_SECRET
        );
    } catch (error) {
        throw new ApiError(401, "invalid or expired refresh token");
    }

    const user = await User.findById(decodedToken?._id);

    if (!user) {
        throw new ApiError(401, "invalid refresh token");
    }

    if (incomingRefreshToken !== user.refreshToken) {
        throw new ApiError(401, "refresh token is expired or already used");
    }

    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(
        user._id
    );

    return res
        .status(200)
        .cookie("accessToken", accessToken, cookieOptions)
        .cookie("refreshToken", refreshToken, cookieOptions)
        .json(
            new ApiResponse(
                200,
                { accessToken, refreshToken },
                "access token refreshed successfully"
            )
        );
});

const changeCurrentPassword = asyncHandler(async (req, res) => {
    const { oldPassword, newPassword } = req.body || {};

    if (!oldPassword || !newPassword) {
        throw new ApiError(400, "both old and new passwords are required");
    }

    const user = await User.findById(req.user?._id);

    if (!user) {
        throw new ApiError(404, "user not found");
    }

    const isPasswordCorrect = await user.isPasswordCorrect(oldPassword);

    if (!isPasswordCorrect) {
        throw new ApiError(400, "old password is incorrect");
    }

    // the pre("save") hook in the model hashes the new password
    user.password = newPassword;
    await user.save({ validateBeforeSave: false });

    return res
        .status(200)
        .json(new ApiResponse(200, {}, "password changed successfully"));
});

const getCurrentUser = asyncHandler(async (req, res) => {
    return res
        .status(200)
        .json(new ApiResponse(200, req.user, "current user fetched successfully"));
});

const updateAccountDetails = asyncHandler(async (req, res) => {
    const { fullName, email } = req.body || {};

    if (!(fullName || email)) {
        throw new ApiError(400, "at least one field (fullName or email) is required");
    }

    // Only update the fields that were actually sent
    const update = {};
    if (fullName) update.fullName = fullName.trim();

    if (email) {
        const normalizedEmail = email.trim().toLowerCase();

        const emailTaken = await User.findOne({
            email: normalizedEmail,
            _id: { $ne: req.user._id },
        });

        if (emailTaken) {
            throw new ApiError(409, "email is already in use");
        }

        update.email = normalizedEmail;
    }

    const user = await User.findByIdAndUpdate(
        req.user?._id,
        { $set: update },
        { new: true }
    ).select("-password -refreshToken");

    return res
        .status(200)
        .json(new ApiResponse(200, user, "account details updated successfully"));
});

const updateUserAvatar = asyncHandler(async (req, res) => {
    const avatarLocalPath = req.file?.path;

    if (!avatarLocalPath) {
        throw new ApiError(400, "avatar file is missing");
    }

    const avatar = await uploadOnCloudinary(avatarLocalPath);

    if (!avatar?.url) {
        throw new ApiError(400, "error while uploading avatar to cloudinary");
    }

    const user = await User.findByIdAndUpdate(
        req.user?._id,
        { $set: { avatar: avatar.url } },
        { new: true }
    ).select("-password -refreshToken");

    return res
        .status(200)
        .json(new ApiResponse(200, user, "avatar image updated successfully"));
});

const updateUserCoverImage = asyncHandler(async (req, res) => {
    const coverImageLocalPath = req.file?.path;

    if (!coverImageLocalPath) {
        throw new ApiError(400, "cover image file is missing");
    }

    const coverImage = await uploadOnCloudinary(coverImageLocalPath);

    if (!coverImage?.url) {
        throw new ApiError(400, "error while uploading cover image to cloudinary");
    }

    const user = await User.findByIdAndUpdate(
        req.user?._id,
        { $set: { coverImage: coverImage.url } },
        { new: true }
    ).select("-password -refreshToken");

    return res
        .status(200)
        .json(new ApiResponse(200, user, "cover image updated successfully"));
});

const getUserChannelProfile = asyncHandler(async (req, res) => {
    const { userName } = req.params;

    if (!userName?.trim()) {
        throw new ApiError(400, "username is missing");
    }

    const channel = await User.aggregate([
        {
            $match: {
                userName: userName.toLowerCase(),
            },
        },
        {
            $lookup: {
                from: "subscriptions",
                localField: "_id",
                foreignField: "channel",
                as: "subscribers",
            },
        },
        {
            $lookup: {
                from: "subscriptions",
                localField: "_id",
                foreignField: "subscriber",
                as: "subscribedTo",
            },
        },
        {
            $addFields: {
                subscribersCount: { $size: "$subscribers" },
                channelsSubscribedToCount: { $size: "$subscribedTo" },
                isSubscribed: {
                    $cond: {
                        if: { $in: [req.user?._id, "$subscribers.subscriber"] },
                        then: true,
                        else: false,
                    },
                },
            },
        },
        {
            $project: {
                fullName: 1,
                userName: 1,
                subscribersCount: 1,
                channelsSubscribedToCount: 1,
                isSubscribed: 1,
                avatar: 1,
                coverImage: 1,
                email: 1,
            },
        },
    ]);

    if (!channel?.length) {
        throw new ApiError(404, "channel does not exist");
    }

    return res
        .status(200)
        .json(
            new ApiResponse(200, channel[0], "user channel fetched successfully")
        );
});

const getWatchHistory = asyncHandler(async (req, res) => {
    const user = await User.aggregate([
        {
            $match: {
                _id: new mongoose.Types.ObjectId(req.user._id),
            },
        },
        {
            $lookup: {
                from: "videos",
                localField: "watchHistory",
                foreignField: "_id",
                as: "watchHistory",
                pipeline: [
                    {
                        $lookup: {
                            from: "users",
                            localField: "owner",
                            foreignField: "_id",
                            as: "owner",
                            pipeline: [
                                {
                                    $project: {
                                        fullName: 1,
                                        userName: 1,
                                        avatar: 1,
                                    },
                                },
                            ],
                        },
                    },
                    {
                        $addFields: {
                            owner: { $first: "$owner" },
                        },
                    },
                ],
            },
        },
    ]);

    if (!user?.length) {
        throw new ApiError(404, "user not found");
    }

    return res
        .status(200)
        .json(
            new ApiResponse(
                200,
                user[0].watchHistory,
                "watch history fetched successfully"
            )
        );
});

export {
    registerUser,
    loginUser,
    logoutUser,
    refreshAccessToken,
    changeCurrentPassword,
    getCurrentUser,
    updateAccountDetails,
    updateUserAvatar,
    updateUserCoverImage,
    getUserChannelProfile,
    getWatchHistory,
};






























// import { asyncHandler } from "../utils/async_handler.js";


// import { ApiError } from "../utils/api_error.js";

// import { User } from "../models/user.model.js";
// import { configDotenv } from "dotenv";
// import { upload } from "../middlewares/multer.middleware.js";
// import { uploadOnCloudinary } from "../utils/cloudinary.js";
// import { ApiResponse } from "../utils/api_response.js";

// import jwt from "jsonwebtoken";
// import mongoose from "mongoose";





// const generateAccessAndRefreshTokens = async (userId) => {
//     try {

//         const user = await User.findById(userId);
//         const accessToken = user.generateAccessToken();
//         const refreshToken = user.generateRefreshToken();

//         user.refreshToken = refreshToken;
//         await user.save({ validateBeforeSave: false });

//         return { accessToken, refreshToken }


//     } catch (error) {
//         throw new ApiError(500, "something went wrong while generating refresh and access tokens");

//     }
// }


// const registerUser = asyncHandler(async (req, res) => {
//     // res.status(200).json({
//     //     message:"ok"
//     // });
//     //res.send("welcome to register user");


//     //to register user
//     //get user detail from frontend
//     //validation - not empty any field
//     //check if user already exists : from username,email
//     //check for images , check for avatar
//     //upload them to cloudinary, check avatar is uploaded
//     //create user object - create entry in db
//     //remove password and refresh token field from response
//     //check for user creation
//     //return res


//     // get user detail from frontend
//     const { fullName, email, userName, password } = req.body || {};

//     // for testing
//     // console.log("fullName:", fullName);
//     // console.log("email:", email);
//     // console.log("userName:", userName);
//     // console.log("password:", password);

//     // actual code 
//     if (fullName === "") {
//         throw new ApiError(400,
//             "full name is required"
//         )
//     };
//     if (email === "") {
//         throw new ApiError(400, "email is required");

//     };
//     if (userName === "") {
//         throw new ApiError(400, "username is required")

//     };
//     if (password === "") {
//         throw new ApiError(400, "password is required")

//     };

//     const existedUser = await User.findOne({
//         $or: [
//             {
//                 userName
//             },
//             {
//                 email
//             }

//         ]

//     });

//     if (existedUser) {
//         console.log("user is already exist");
//         throw new ApiError(409, "user already exist");
//     };


//     // multer gives us 
//     const avatarLocalPath = req.files?.avatar?.[0]?.path;
//     const coverImageLocalPath = req.files?.coverImage?.[0]?.path;

//     if (!avatarLocalPath) {
//         throw new ApiError(400, "avatar image is required");
//     }

//     const avatar = await uploadOnCloudinary(avatarLocalPath);
//     const coverImage = await coverImageLocalPath
//         ? await uploadOnCloudinary(coverImageLocalPath)
//         : null;


//     if (!avatar) {
//         throw new ApiError(400, "Try Again");

//     }


//     const user = await User.create({
//         fullName,
//         avatar: avatar.url,
//         coverImage: coverImage?.url || "",
//         email,
//         password,
//         userName: userName.toLowerCase(),

//     });

//     const createdUser = await User.findById(user._id).select(
//         "-password -refreshToken"// password and refreshToken is hided
//     )

//     if (!createdUser) {
//         throw new ApiError(500, "something went wrong while registering the user")
//     }


//     return res.status(200).json(
//         new ApiResponse(200, createdUser, "user Registered succesfully")
//     );


// });


// const loginUser = asyncHandler(async (req, res) => {

//     // req.body -> data 
//     // userName or email
//     //find user
//     //password check
//     //access and refresh token(generate)
//     //send cookie

//     const { email, userName, password } = req.body || {};

//     console.log(`${email},${password},${userName}`);

//     if (!(email || userName)) {
//         throw new ApiError(400, "username or email is required")
//     };

//     const user = await User.findOne({
//         $or: [
//             {
//                 userName
//             },
//             {
//                 email
//             }
//         ]
//     });


//     if (!user) {
//         throw new ApiError(404, "Invalid user or user not exist")
//     }

//     const isPasswordValid = await user.isPasswordCorrect(password);

//     if (!isPasswordValid) {
//         throw new ApiError(401, "incorrect password");
//     }

//     const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id)


//     const logedInUser = await User.findById(user._id).select("-password -refreshToken")
//     const options = {
//         httpOnly: true,
//         secure: true
//     }

//     return res
//         .status(200)
//         .cookie("accessToken", accessToken, options)
//         .cookie("refreshToken", refreshToken, options)
//         .json(
//             new ApiResponse(
//                 200,
//                 {
//                     user: logedInUser, accessToken,
//                     refreshToken
//                 },
//                 "User logged In successfully"
//             )
//         )

// });

// const logoutUser = asyncHandler(async (req, res) => {
//     await User.findByIdAndUpdate(
//         req.user._id,
//         {
//             $unset: {
//                 refreshToken: 1,
//                 accessToken: 1
//             }

//         },
//         {
//             new: true,
//         }

//     )

//     const options = {
//         httpOnly: true,
//         secure: true
//     }

//     return res
//         .status(200)
//         .clearCookie("accessToken", options)
//         .clearCookie("refreshToken", options)
//         .json(new ApiResponse(200, {}, "user logged out successfully"))
// });

// const refreshAccessToken = asyncHandler(async (req, res) => {
//     try {
//         const incommingRefreshToken = req.cookies?.refreshToken || req.body?.refreshToken;

//         if (!incommingRefreshToken) {
//             throw new ApiError(401, "unauthorized request")
//         };

//         const decodedToken = jwt.verify(
//             incommingRefreshToken,
//             process.env.REFRESH_TOKEN_SECRET



//         );

//         const user = await User.findById(
//             decodedToken?._id
//         );
//         if (!user) {
//             throw new ApiError(401, "invalid refresh token");
//         };

//         if (incommingRefreshToken !== user.refreshToken) {
//             throw new ApiError(400, "refresh token is expired or used")
//         }

//         const options = {
//             httpOnly: true,
//             secure: true,
//             sameSite: 'strict',
//         }

//         const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id);

//         return res
//             .status(200)
//             .cookie("accessToken", accessToken, options)
//             .cookie("refreshToken", refreshToken, options)
//             .json(
//                 new ApiResponse(
//                     200,
//                     {
//                         accessToken,
//                         refreshToken,
//                     },
//                     "Access Token Refreshed Successfully!!"
//                 )
//             )
//     } catch (error) {
//         throw new ApiError(401, error?.message)
//     }



// });



// const changeCurrentPassword = asyncHandler(async (req, res) => {
//     const { oldPassword, newPassword } = req.body || {};
//     const user = await User.findById(req.user?._id);
//     const isPasswordCorrect = await user.isPasswordCorrect(oldPassword);


//     if (!isPasswordCorrect) {
//         throw new ApiError(400, "wrong password");
//     };

//     user.password = newPassword;
//     await user.save({
//         validateBeforeSave: false
//     });

//     return res
//         .status(200)
//         .json(new ApiResponse(200, {}, "password changed successfully"));





// });



// const getCurrentUser = asyncHandler(async (req, res) => {
//     return res
//         .status(200)
//         .json(new ApiResponse(200, req.user, "current user fetched successfully"));
// });



// const updateAccountDetails = asyncHandler(async (req, res) => {
//     const { fullName, email } = req.body || {};
//     if (!(fullName || email)) {
//         throw new ApiError(400, "All fields are required!");
//     };
//     const user = await User.findByIdAndUpdate(
//         req.user?._id,
//         {
//             $set: {
//                 fullName: fullName,
//                 email: email
//             }
//         },
//         {
//             new: true
//         }
//     ).select("-password")

//     return res
//         .status(200)
//         .json(new ApiResponse(200, user, "Account details updated successfully!"));

// });

// const updateUserAvatar = asyncHandler(async (req, res) => {
//     const avatarLocalPath = req.file?.path;
//     if (!avatarLocalPath) {
//         throw new ApiError(400, "avatar file is missing!");
//     };
//     const avatar = await uploadOnCloudinary(avatarLocalPath);

//     if (!avatar.url) {
//         throw new ApiError(400, "Error while uploading avatar on cloudinary!");

//     }

//     const user = await User.findByIdAndUpdate(
//         req.user?._id,
//         {
//             $set: {
//                 avatar: avatar.url
//             },

//         },
//         {
//             new: true
//         }
//     ).select("-password");

//     return res
//         .status(200)
//         .json(new ApiResponse(200, user, "avatar Image is updated successfully!"))
// });

// // create updateUserCoverImage 
// // i can create (updateUserCoverImage) endpoit as same as (updateUserAvatar)


// const getUserChannelProfile = asyncHandler(async (req, res) => {
//     const { userName } = req.params;
//     if (!userName.trim()) {
//         throw new ApiError(400, "username is missing");
//     };

//     const channel = User.aggregate([
//         {
//             $match: {
//                 userName: userName?.toLowerCase()
//             },


//         },

//         {
//             $lookup: {
//                 from: "subscriptions",
//                 foreignField: "channel",
//                 localField: "_id",
//                 as: "subscribers"
//             }
//         },

//         {
//             $lookup: {
//                 from: "subscriptions",
//                 foreignField: "subscriber",
//                 localField: "_id",
//                 as: "subscribedTo"
//             }
//         },


//         {
//             $addFields: {
//                 subscribersCount: {
//                     $size: "$subscribers"
//                 },
//                 channelsSubscribedToCount: {
//                     $size: "subscribedTo"
//                 },
//                 isSubscribed: {

//                     $cond: {


//                         if: {
//                             $in: [req.user?._id, "$subscribers.subscriber"]
//                         }, then: true,
//                         else: false
//                     }
//                 }

//             }
//         },
//         {
//             $project: {
//                 fullName: 1,
//                 userName: 1,
//                 subscribersCount: 1,
//                 channelsSubscribedToCount: 1,
//                 isSubscribed: 1,
//                 avatar: 1,
//                 coverImage: 1,
//                 email: 1
//             }
//         }


//     ])


//     if (!channel?.length) {
//         throw new ApiError(404, "channel does not exist");
//     }

//     return res
//         .status(200)
//         .json(
//             new ApiError(200, channel[0], "User channel fetched successfull")
//         )


// });

// const getWatchHistory = asyncHandler(async (req, res) => {
//     const user = await User.aggregate([
//         {
//             $match: {
//                 _id: new mongoose.Types.ObjectId(req.user._id)
//             }
//         },
//         {
//             $lookup: {
//                 from: "videos",
//                 localField: "watchHistory",
//                 foreignField: "_id",
//                 as: "watchHistory",
//                 pipeline: [
//                     {
//                         $lookup: {
//                             from: "users",
//                             localField: "owner",
//                             foreignField: "_id",
//                             as: "owner",
//                             pipeline: [
//                                 {
//                                     $project: {
//                                         fullName: 1,
//                                         userName: 1,
//                                         avatar: 1
//                                     }
//                                 }
//                             ]
//                         }
//                     },
//                     {
//                         $addFields: {
//                             owner: {
//                                 $first: "$owner"
//                             }
//                         }
//                     }
//                 ]
//             }
//         }

//     ]);

//     // return res
//     //     .status(200)
//     //     .json(
//     //         new ApiResponse(200, user[0].watchHistory, "retrive watch History successfully")
//     // );

//     return res.status(200).json(
//         new ApiResponse(200, user[0].watchHistory, "retrive watch History successfully")
//     );


// })





// export {
//     registerUser,
//     loginUser,
//     logoutUser,
//     refreshAccessToken,
//     changeCurrentPassword,
//     getCurrentUser,
//     updateAccountDetails,
//     updateUserAvatar,
//     getUserChannelProfile,
//     getWatchHistory
// };
