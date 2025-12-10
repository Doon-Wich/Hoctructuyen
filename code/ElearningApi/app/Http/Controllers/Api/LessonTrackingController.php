<?php

namespace App\Http\Controllers\Api;

use App\Models\LessonTracking;
use App\Models\StudentLesson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class LessonTrackingController extends BaseResourceController
{
    public function getTracking($lesson_id)
    {
        $tracking = LessonTracking::where('student_id', Auth::id())
            ->where('lesson_id', $lesson_id)
            ->first();

        return response()->json([
            'data' => $tracking
        ]);
    }

    public function updateProgress(Request $request)
    {
        $request->validate([
            'lesson_id' => 'required|integer',
            'last_position' => 'nullable|integer',
            'duration' => 'nullable|integer',
        ]);

        $studentId = Auth::id();
        $lessonId = $request->lesson_id;
        $position = $request->last_position ?? 0;
        $duration = max(1, $request->duration ?? 0);

        $tracking = LessonTracking::where('student_id', $studentId)
            ->where('lesson_id', $lessonId)
            ->first();


        if ($tracking && $position <= $tracking->last_position) {
            return response()->json([
                'success' => false,
                'message' => 'Không cập nhật vì vị trí nhỏ hơn tiến độ hiện tại',
            ]);
        }

        $nowVN = Carbon::now('Asia/Ho_Chi_Minh');
        $percent = min(100, round(($position / $duration) * 100));
        $isCompleted = $percent >= 95;

        $additionalTime = 0;
        if ($tracking && $position > $tracking->last_position) {
            $additionalTime = $position - $tracking->last_position;
        }

        $totalWatchedTime = ($tracking->total_watched_time ?? 0) + $additionalTime;

        LessonTracking::updateOrCreate(
            ['student_id' => $studentId, 'lesson_id' => $lessonId],
            [
                'last_position' => $position,
                'total_watched_time' => $totalWatchedTime,
                'progress_percent' => $percent,
                'is_completed' => $isCompleted,
                'last_viewed' => $nowVN,
            ]
        );

        if ($isCompleted) {
            $studentLesson = StudentLesson::where('student_id', $studentId)
                ->where('lesson_id', $lessonId)
                ->first();

            if ($studentLesson) {
                StudentLesson::where('student_id', $studentId)
                    ->where('lesson_id', $lessonId)
                    ->update([
                        'progress' => $percent,
                        'completed_datetime' => $nowVN,
                        'last_viewed' => $nowVN,
                    ]);
            } else {
                StudentLesson::create([
                    'student_id' => $studentId,
                    'lesson_id' => $lessonId,
                    'progress' => $percent,
                    'completed_datetime' => $nowVN,
                    'last_viewed' => $nowVN,
                ]);
            }
        }

        return response()->json([
            'success' => true,
            'progress' => $percent,
            'is_completed' => $isCompleted,
            'total_watched_time' => $totalWatchedTime,
        ]);
    }
}
