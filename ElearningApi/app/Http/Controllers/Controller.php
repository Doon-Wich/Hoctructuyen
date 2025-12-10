<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

class Controller extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

    function statusResponse($status , $statusCode , $message, $data) {
        return response()->json([
            'statusCode' => $statusCode,
            'message' => $message,
            'data' => $data
        ], $status);
    }

}
