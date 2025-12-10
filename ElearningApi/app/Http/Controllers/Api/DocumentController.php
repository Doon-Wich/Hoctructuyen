<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Jobs\ProcessDocumentJob;
use App\Models\Document;
use Illuminate\Http\Request;

class DocumentController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'course_id' => 'required',
            'title' => 'required',
            'file' => 'required|file|mimes:pdf,txt,md,docx|max:100000',
        ]);

        $path = $request->file('file')->store('documents', 'public');

        $document = Document::create([
            'course_id' => $request->course_id,
            'module_id' => $request->module_id,
            'lesson_id' => $request->lesson_id,
            'title' => $request->title,
            'file_path' => $path,
            'mime_type' => $request->file('file')->getClientMimeType(),
            'status' => 'pending'
        ]);

        dispatch(new ProcessDocumentJob($document->id));

        return response()->json([
            'message' => 'Uploaded successfully',
            'document' => $document
        ]);
    }
}
