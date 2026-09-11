import { Router } from "express";

const router = Router();

import { verifyJWT } from "../middlewares/auth.middleware.js"


import {
    getAllVideos,
    publishAVideo,
    getVideoById,
    deleteVideo
} from "../controllers/video.controller.js";


import { upload } from "../middlewares/multer.middleware.js";


router.route("/").get(verifyJWT, getAllVideos);

router.route("/publish").post(verifyJWT, upload.single("video"), publishAVideo)

router.route("/:videoId").get(verifyJWT, getVideoById)

router.route("/:delete").delete(verifyJWT, deleteVideo)


export default router;