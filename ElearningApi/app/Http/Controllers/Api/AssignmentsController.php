<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\Assignment;

class AssignmentsController extends BaseResourceController
{
    protected $model = Assignment::class;
    protected $with = ['lesson']; // load luôn lesson khi lấy data

    /**
     * Validation rules khi tạo mới
     */
    protected function getStoreValidationRules()
    {
        return [
            'lesson_id'   => 'required|exists:lesson,id',
            'title'       => 'required|string|max:255',
            'description' => 'nullable|string',
            'attachment'  => 'nullable|string',
            'deadline'    => 'nullable|date',
        ];
    }

    /**
     * Validation rules khi update
     */
    protected function getUpdateValidationRules($id)
    {
        return [
            'lesson_id'   => 'sometimes|required|exists:lesson,id',
            'title'       => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'attachment'  => 'nullable|string',
            'deadline'    => 'nullable|date',
        ];
    }

    /**
     * Lấy danh sách bài tập theo lesson
     */
    public function getByLesson($lessonId)
    {
        $assignments = Assignment::with($this->with)
            ->where('lesson_id', $lessonId)
            ->orderBy('id', 'desc')
            ->get();

        return $this->statusResponse(200, 200, 'Thành công', $assignments);
    }
}
