<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseResourceController;
use App\Models\Assignment;
use App\Models\StudentAssignmentSubmission;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class StudentAssignmentController extends BaseResourceController
{
    protected $model = StudentAssignmentSubmission::class;

    protected $with = ['assignment'];

    protected function getStoreValidationRules()
    {
        return [
            'assignment_id' => 'required|exists:assignments,id',
            'file_upload' => 'nullable|string', // nhận URL hoặc path
            'content' => 'nullable|string',
        ];
    }

    public function index(Request $request)
    {
        $query = Assignment::with('lesson')->orderBy('id', 'desc');

        // Nếu truyền lesson_id, lọc theo lesson
        if ($request->has('lesson_id')) {
            $query->where('lesson_id', $request->query('lesson_id'));
        }

        $data = $query->get();

        // Trả về chuẩn data
        return $this->statusResponse(200, 200, 'Thành công', ['data' => $data]);
    }

    public function store(Request $request)
    {
        $request->validate($this->getStoreValidationRules());

        $filePath = $request->input('file_upload') ?? null;

        $submission = StudentAssignmentSubmission::updateOrCreate(
            [
                'assignment_id' => $request->input('assignment_id'),
                'student_id'    => Auth::id(),
            ],
            [
                'content'       => $request->input('content'),
                'file_upload'   => $filePath,
                'submitted_at'  => now(),
                'status'        => 'submitted',
            ]
        );

        return $this->statusResponse(200, 200, "Nộp bài thành công", [
            'submission_id' => $submission->id,
            'content'       => $submission->content,
            'file_upload'   => $filePath, 
            'submitted_at'  => $submission->submitted_at,
        ]);
    }

    public function getByAssignment($assignmentId)
    {
        $submission = StudentAssignmentSubmission::where('assignment_id', $assignmentId)
            ->where('student_id', Auth::id())
            ->first();

        if (!$submission) {
            return $this->statusResponse(200, 200, "Chưa nộp bài", [
                'content' => "",
                'file_upload' => null, 
                'submitted_at' => null,
                'score' => null,
                'teacher_feedback' => null,
            ]);
        }

        return $this->statusResponse(200, 200, "", [
            'content'          => $submission->content,
            'file_upload'      => $submission->file_upload, 
            'submitted_at'     => $submission->submitted_at,
            'score'            => $submission->score,
            'teacher_feedback' => $submission->teacher_feedback,
        ]);
    }
}
