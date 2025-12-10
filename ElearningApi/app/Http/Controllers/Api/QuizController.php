<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseResourceController;
use App\Models\Quiz;
use App\Models\QuizQuestion;
use App\Models\QuizAnswer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class QuizController extends BaseResourceController
{
    protected $model = Quiz::class;
    protected $title = "Quiz";
    protected $with = ['quiz_questions.quiz_answers'];

    /** RULES: Tạo Quiz */
    protected function getStoreValidationRules()
    {
        return [
            'course_id' => 'required|integer',
            'name' => 'required|string|max:255',
        ];
    }

    /** RULES: Update Quiz */
    protected function getUpdateValidationRules($id)
    {
        return [
            'course_id' => 'sometimes|integer',
            'name' => 'sometimes|string|max:255',
        ];
    }

    public function store(Request $request)
    {
        $request->validate([
            'course_id' => 'required|integer',
            'name' => 'required|string|max:255',
        ]);

        $quiz = Quiz::create($request->all());

        return parent::statusResponse(200, 200, "Tạo quiz thành công", $quiz);
    }

    public function update(Request $request, $id)
    {
        $quiz = Quiz::find($id);

        if (!$quiz) {
            return parent::statusResponse(200, 404, "Quiz không tồn tại", "");
        }

        $quiz->update($request->all());

        return parent::statusResponse(200, 200, "Cập nhật quiz thành công", $quiz);
    }

    public function delete($id)
    {
        $quiz = Quiz::find($id);

        if (!$quiz) {
            return parent::statusResponse(200, 404, "Quiz không tồn tại", "");
        }

        $quiz->delete();

        return parent::statusResponse(200, 200, "Xóa quiz thành công", "");
    }
    /**
     * =============== CUSTOM API ===============
     *  Tạo câu hỏi + đáp án cùng lúc (giống Wayground)
     * ==========================================
     */
    public function getQuestions($quizId)
    {
        $questions = QuizQuestion::with('quiz_answers')
            ->where('quiz_id', $quizId)
            ->get();

        return parent::statusResponse(200, 200, "Danh sách câu hỏi", $questions);
    }

    public function storeQuestion(Request $request, $quizId)
    {
        $request->validate([
            'question_title' => 'required|string|max:500',
            'answers' => 'required|array|min:4',
            'answers.*.answer_text' => 'required|string|max:255',
            'answers.*.is_correct' => 'required|boolean',
        ]);

        // Check có ít nhất 1 đáp án đúng
        if (!collect($request->answers)->contains('is_correct', true)) {
            return parent::statusResponse(200, 400, 'Phải có ít nhất 1 đáp án đúng', '');
        }

        DB::beginTransaction();
        try {
            // Create question
            $question = QuizQuestion::create([
                'quiz_id' => $quizId,
                'question_title' => $request->question_title,
            ]);

            // Create answers
            foreach ($request->answers as $ans) {
                QuizAnswer::create([
                    'question_id' => $question->id,
                    'answer_text' => $ans['answer_text'],
                    'is_correct' => $ans['is_correct'],
                ]);
            }

            DB::commit();

            return parent::statusResponse(200, 200, "Tạo câu hỏi thành công", $question);
        } catch (\Exception $e) {
            DB::rollBack();
            return parent::statusResponse(200, 500, 'Lỗi hệ thống', $e->getMessage());
        }
    }

    /**
     * Update câu hỏi + đáp án
     */
    public function updateQuestion(Request $request, $questionId)
    {
        $request->validate([
            'question_title' => 'required|string|max:500',
            'answers' => 'required|array|min:4',
            'answers.*.id' => 'nullable|integer',
            'answers.*.answer_text' => 'required|string|max:255',
            'answers.*.is_correct' => 'required|boolean',
        ]);

        if (!collect($request->answers)->contains('is_correct', true)) {
            return parent::statusResponse(200, 400, 'Phải có ít nhất 1 đáp án đúng', '');
        }

        DB::beginTransaction();
        try {
            $question = QuizQuestion::find($questionId);
            if (!$question) {
                return parent::statusResponse(200, 404, 'Không tìm thấy câu hỏi', '');
            }

            $question->update([
                'question_title' => $request->question_title,
            ]);

            // Sync answers
            $existingAnswerIds = $question->quiz_answers->pluck('id')->toArray();
            $incomingIds = collect($request->answers)->pluck('id')->filter()->toArray();

            // Xóa những đáp án không còn
            $toDelete = array_diff($existingAnswerIds, $incomingIds);
            QuizAnswer::whereIn('id', $toDelete)->delete();

            // Update hoặc create
            foreach ($request->answers as $ans) {
                if (!empty($ans['id'])) {
                    QuizAnswer::where('id', $ans['id'])->update([
                        'answer_text' => $ans['answer_text'],
                        'is_correct' => $ans['is_correct'],
                    ]);
                } else {
                    QuizAnswer::create([
                        'question_id' => $questionId,
                        'answer_text' => $ans['answer_text'],
                        'is_correct' => $ans['is_correct'],
                    ]);
                }
            }

            DB::commit();
            return parent::statusResponse(200, 200, "Cập nhật câu hỏi thành công", $question);
        } catch (\Exception $e) {
            DB::rollBack();
            return parent::statusResponse(200, 500, 'Lỗi hệ thống', $e->getMessage());
        }
    }

    public function deleteQuestion($id)
    {
        $question = QuizQuestion::find($id);
        if (!$question) {
            return parent::statusResponse(200, 404, 'Không tìm thấy câu hỏi', '');
        }

        QuizAnswer::where('question_id', $id)->delete();
        $question->delete();

        return parent::statusResponse(200, 200, 'Xóa câu hỏi thành công', '');
    }
}
