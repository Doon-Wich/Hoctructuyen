<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class QuizQuestion
 * 
 * @property int $id
 * @property int $quiz_id
 * @property string $question_title
 * 
 * @property Quiz $quiz
 * @property Collection|QuizAnswer[] $quiz_answers
 * @property Collection|StudentAnswer[] $student_answers
 *
 * @package App\Models
 */
class QuizQuestion extends Model
{
	protected $table = 'quiz_question';
	public $timestamps = false;

	protected $casts = [
		'quiz_id' => 'int'
	];

	protected $fillable = [
		'quiz_id',
		'question_title'
	];

	public function quiz()
	{
		return $this->belongsTo(Quiz::class);
	}

	public function quiz_answers()
	{
		return $this->hasMany(QuizAnswer::class, 'question_id');
	}

	public function student_answers()
	{
		return $this->hasMany(StudentAnswer::class, 'question_id');
	}
}
