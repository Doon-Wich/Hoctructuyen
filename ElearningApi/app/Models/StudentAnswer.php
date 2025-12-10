<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class StudentAnswer
 * 
 * @property int $id
 * @property int $attempt_id
 * @property int $question_id
 * @property int|null $answer_id
 * @property string|null $answer_text
 * @property bool|null $is_correct
 * 
 * @property StudentQuizAttempt $student_quiz_attempt
 * @property QuizQuestion $quiz_question
 * @property QuizAnswer|null $quiz_answer
 *
 * @package App\Models
 */
class StudentAnswer extends Model
{
	protected $table = 'student_answer';
	public $timestamps = false;

	protected $casts = [
		'attempt_id' => 'int',
		'question_id' => 'int',
		'answer_id' => 'int',
		'is_correct' => 'bool'
	];

	protected $fillable = [
		'attempt_id',
		'question_id',
		'answer_id',
		'answer_text',
		'is_correct'
	];

	public function student_quiz_attempt()
	{
		return $this->belongsTo(StudentQuizAttempt::class, 'attempt_id');
	}

	public function quiz_question()
	{
		return $this->belongsTo(QuizQuestion::class, 'question_id');
	}

	public function quiz_answer()
	{
		return $this->belongsTo(QuizAnswer::class, 'answer_id');
	}
}
