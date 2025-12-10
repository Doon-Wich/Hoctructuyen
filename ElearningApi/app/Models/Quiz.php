<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Quiz
 * 
 * @property int $id
 * @property int $course_id
 * @property string $name
 * @property int|null $number
 * @property int|null $course_order
 * @property int|null $min_pass_score
 * @property bool|null $is_pass_required
 * 
 * @property Course $course
 * @property Collection|QuizQuestion[] $quiz_questions
 * @property Collection|StudentQuizAttempt[] $student_quiz_attempts
 *
 * @package App\Models
 */
class Quiz extends Model
{
	protected $table = 'quiz';
	public $timestamps = false;

	protected $casts = [
		'course_id' => 'int',
		'number' => 'int',
		'course_order' => 'int',
		'min_pass_score' => 'int',
		'is_pass_required' => 'bool'
	];

	protected $fillable = [
		'course_id',
		'name',
		'number',
		'course_order',
		'min_pass_score',
		'is_pass_required'
	];

	public function course()
	{
		return $this->belongsTo(Course::class);
	}

	public function quiz_questions()
	{
		return $this->hasMany(QuizQuestion::class);
	}

	public function student_quiz_attempts()
	{
		return $this->hasMany(StudentQuizAttempt::class);
	}
}
