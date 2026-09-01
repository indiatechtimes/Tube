import { ApiError } from "../utils/api_error.js";
import {
    asyncHandler
} from "../utils/async_handler.js";

import { ApiResponse } from "../utils/api_response.js";

const healthcheck = asyncHandler(async (req, res) => {
    return res
        .status(200)
        .json(
            new ApiResponse(200, {}, "controllers are working properly")
        )
})

export { healthcheck };