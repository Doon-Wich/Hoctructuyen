<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\Controller;

class FileUploadController extends Controller
{
    /**
     * Upload file chung cho nhiều module
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function upload(Request $request)
    {
        $request->validate([
            'file' => 'required|file|max:10240', // max 10MB
            'folder' => 'nullable|string',       // optional folder
        ]);

        $file = $request->file('file');
        $folder = $request->input('folder', 'uploads'); // default folder nếu không truyền

        // Lưu vào storage/app/public/{folder}
        $path = $file->store($folder, 'public');

        // URL public để frontend truy cập
        $url = Storage::url($path);

        return response()->json([
            'status' => 200,
            'message' => 'Upload thành công',
            'data' => [
                'url' => $url,
                'path' => $path,
                'name' => $file->getClientOriginalName(),
            ],
        ]);
    }
}
