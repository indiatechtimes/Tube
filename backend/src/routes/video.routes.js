import { Router } from "express";

const router = Router();

import { verifyJWT } from "../middlewares/auth.middleware.js"


import { getAllVideos, publishAVideo } from "../controllers/video.controller.js";
import { upload } from "../middlewares/multer.middleware.js";


router.route("/").get(verifyJWT, getAllVideos);

router.route("/publish").post(verifyJWT,upload.single("video"),publishAVideo)


export default router;