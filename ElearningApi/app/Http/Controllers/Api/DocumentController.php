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
            'lesson_id' => 'required',
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
            'original_name' => $request->file('file')->getClientOriginalName(),
            'file_type' => $request->file('file')->getClientMimeType(),
            'status' => 'pending'
        ]);

        dispatch(new ProcessDocumentJob($document->id));

        return response()->json([
            'message' => 'Uploaded successfully',
            'document' => $document
        ]);
    }

    public function getByLesson($lessonId)
    {
        return response()->json([
            'data' => Document::where('lesson_id', $lessonId)->first()
        ]);
    }
}
