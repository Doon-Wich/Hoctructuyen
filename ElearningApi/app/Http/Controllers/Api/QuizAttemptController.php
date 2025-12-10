<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Api\BaseResourceController;
use App\Models\Quiz;
use App\Models\StudentAnswer;
use App\Models\StudentQuizAttempt;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class QuizAttemptController extends BaseResourceController
{
    public function submit(Request $request, $quizId)
    {
        $user = Auth::user();
        $quiz = Quiz::with('quiz_questions.quiz_answers')->find($quizId);

        if (!$quiz) {
            return response()->json(['status' => 'error', 'message' => 'Quiz không tồn tại'], 404);
        }

        $existingAttempt = StudentQuizAttempt::where('student_id', $user->id)
            ->where('quiz_id', $quizId)
            ->orderBy('attempt_datetime', 'desc')
            ->first();

        if ($existingAttempt) {
            return response()->json([
                'status' => 'error',
                'message' => 'Bạn đã hoàn thành bài kiểm tra này',
                'data' => [
                    'score' => $existingAttempt->score_achieved,
                    'passed' => $existingAttempt->score_achieved >= ($quiz->min_pass_score ?? 0) * 10
                ]
            ], 400);
        }

        $answers = $request->input('answers', []);
        $totalQuestions = $quiz->quiz_questions->count();

        if ($totalQuestions === 0) {
            return response()->json(['status' => 'error', 'message' => 'Quiz chưa có câu hỏi'], 400);
        }

        $attempt = StudentQuizAttempt::create([
            'student_id' => $user->id,
            'quiz_id' => $quiz->id,
            'attempt_datetime' => Carbon::now(),
            'score_achieved' => 0,
        ]);

        $score = 0;

        foreach ($quiz->quiz_questions as $question) {
            $selectedAnswerId = $answers[$question->id] ?? null;
            $correctAnswer = $question->quiz_answers->firstWhere('is_correct', true);

            if ($selectedAnswerId && $correctAnswer && $selectedAnswerId == $correctAnswer->id) {
                $score += 1;
            }

            StudentAnswer::create([
                'attempt_id' => $attempt->id,
                'student_id' => $user->id,
                'question_id' => $question->id,
                'answer_id' => $selectedAnswerId,
            ]);
        }

        $scorePercent = round(($score / $totalQuestions) * 100);
        $attempt->update(['score_achieved' => $scorePercent]);

        $passed = $scorePercent >= ($quiz->min_pass_score ?? 0) * 10;

        return response()->json([
            'status' => 'success',
            'data' => [
                'score' => $scorePercent,
                'total' => 100,
                'passed' => $passed
            ]
        ]);
    }

    public function getAttempt($quizId)
    {
        $user = Auth::user();
        $attempt = StudentQuizAttempt::where('student_id', $user->id)
            ->where('quiz_id', $quizId)
            ->orderBy('attempt_datetime', 'desc')
            ->first();

        if (!$attempt) return response()->json(['data' => null]);

        return response()->json(['data' => [
            'score' => $attempt->score_achieved,
            'passed' => $attempt->score_achieved >= ($attempt->quiz->min_pass_score ?? 0) * 10
        ]]);
    }
}
