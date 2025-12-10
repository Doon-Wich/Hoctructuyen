<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class StudentQuizAttempt
 * 
 * @property int $id
 * @property int $student_id
 * @property int $quiz_id
 * @property Carbon|null $attempt_datetime
 * @property int|null $score_achieved
 * 
 * @property User $user
 * @property Quiz $quiz
 * @property Collection|StudentAnswer[] $student_answers
 *
 * @package App\Models
 */
class StudentQuizAttempt extends Model
{
	protected $table = 'student_quiz_attempt';
	public $timestamps = false;

	protected $casts = [
		'student_id' => 'int',
		'quiz_id' => 'int',
		'attempt_datetime' => 'datetime',
		'score_achieved' => 'int'
	];

	protected $fillable = [
		'student_id',
		'quiz_id',
		'attempt_datetime',
		'score_achieved'
	];

	public function user()
	{
		return $this->belongsTo(User::class, 'student_id');
	}

	public function quiz()
	{
		return $this->belongsTo(Quiz::class);
	}

	public function student_answers()
	{
		return $this->hasMany(StudentAnswer::class, 'attempt_id');
	}
}
