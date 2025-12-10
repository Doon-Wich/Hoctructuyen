<?php

namespace App\Http\Controllers\Api;

use App\Models\StudentAssignmentSubmission;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TeacherAssignmentController extends BaseResourceController
{
    protected $model = StudentAssignmentSubmission::class;
    protected $with = ['student'];

    public function submissions($assignmentId)
    {
        $submissions = $this->model::with($this->with)
            ->where('assignment_id', $assignmentId)
            ->orderBy('submitted_at', 'desc')
            ->get();

        return $this->statusResponse(200, 200, '', $submissions->map(function ($s) {
            return [
                'id' => $s->id,
                'student' => [
                    'id' => $s->student->id,
                    'name' => $s->student->full_name,
                    'email' => $s->student->email,
                ],
                'content' => $s->content,
                'file_url' => $s->file_upload ? Storage::url($s->file_upload) : null,
                'submitted_at' => $s->submitted_at,
                'score' => $s->score,
                'teacher_feedback' => $s->teacher_feedback,
                'graded_at' => $s->graded_at,
            ];
        }));
    }

    public function grade(Request $request, $submissionId)
    {
        $request->validate([
            'score' => 'required|integer|min:0|max:100',
            'teacher_feedback' => 'nullable|string|max:5000',
            'content' => 'nullable|string',

        ]);

        $submission = $this->model::findOrFail($submissionId);

        $submission->update([
            'score' => $request->score,
            'teacher_feedback' =>  $request->teacher_feedback,
            'graded_at' => now(),
            'status' => 'graded',
        ]);

        return $this->statusResponse(200, 200, 'Chấm bài thành công', $submission);
    }
}
