<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class QuizAnswer
 * 
 * @property int $id
 * @property int $question_id
 * @property string|null $answer_text
 * @property bool|null $is_correct
 * 
 * @property QuizQuestion $quiz_question
 * @property Collection|StudentAnswer[] $student_answers
 *
 * @package App\Models
 */
class QuizAnswer extends Model
{
	protected $table = 'quiz_answer';
	public $timestamps = false;

	protected $casts = [
		'question_id' => 'int',
		'is_correct' => 'bool'
	];

	protected $fillable = [
		'question_id',
		'answer_text',
		'is_correct'
	];

	public function quiz_question()
	{
		return $this->belongsTo(QuizQuestion::class, 'question_id');
	}

	public function student_answers()
	{
		return $this->hasMany(StudentAnswer::class, 'answer_id');
	}
}
