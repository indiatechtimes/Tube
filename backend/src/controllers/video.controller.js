import { Video } from "../models/video.model.js";
import { ApiError } from "../utils/api_error.js";
import { ApiResponse } from "../utils/api_response.js";
import { asyncHandler } from "../utils/async_handler.js";

import { uploadOnCloudinary } from "../utils/cloudinary.js";

const getAllVideos = asyncHandler(async (req, res) => {

});


const publishAVideo = asyncHandler(async (req, res) => {

    // user (who is uploading)
    const user = req.user._id;
    console.log(`user id is ${user}`);
    if (!user) {
        throw new ApiError(401, "unauthorized");
    };



    // what video 
    const localVideoPath = req.file?.path;
    console.log(`the path is ${localVideoPath}`);
    if (!localVideoPath) {
        throw new ApiError(400, "Video is required")
    }

    const uploadedVideo = await uploadOnCloudinary(localVideoPath);

    if (!uploadedVideo) {
        throw new ApiError(500, "error while uploading on cloudinary")
    }
    //console.log(uploadedVideo);
    const videoUrl = uploadedVideo.url;
    const videoDuration = uploadedVideo.duration;
    console.log(`video url is ${videoUrl}`);
    console.log(`videoDuration is ${videoDuration}`);



    // video information
    const { title, description } = await req.body || {};

    if (!title) {
        throw new ApiError(400, "title is required")
    };
    if (!description) {
        throw new ApiError(400, "description is required")
    };
    console.log(title);
    console.log(description);


    const video = await Video.create({

        videoFile: videoUrl,
        title,
        description,
        duration: videoDuration,

        owner: user
    })

    if (!video) {
        throw new ApiError(500, "something is went wrong");
    };

    return res
        .status(200)
        .json(
            new ApiResponse(200, video, "video is uploaded successfully")
        )


})

export {
    getAllVideos,
    publishAVideo,
}