import { ApiError } from "../utils/api_error.js";
import { asyncHandler } from "../utils/async_handler.js";



const getAllVideos = asyncHandler(async (req, res) => {
    
});


const publishAVideo = asyncHandler(async (req, res) => {

    const { video } = req.body || {};
    
    if (!video) {
        throw new ApiError(400,"video required")
    }
    console.log("video is required")
    
})

export {
    getAllVideos,
    publishAVideo,
}