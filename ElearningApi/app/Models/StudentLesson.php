<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class StudentLesson
 * 
 * @property int $student_id
 * @property int $lesson_id
 * @property Carbon|null $completed_datetime
 * @property int|null $progress
 * @property Carbon|null $last_viewed
 * 
 * @property User $user
 * @property Lesson $lesson
 *
 * @package App\Models
 */
class StudentLesson extends Model
{
	protected $table = 'student_lesson';
	public $incrementing = false;
	public $timestamps = false;

	protected $casts = [
		'student_id' => 'int',
		'lesson_id' => 'int',
		'completed_datetime' => 'datetime',
		'progress' => 'int',
		'last_viewed' => 'datetime'
	];

	protected $fillable = [
		'student_id',
		'lesson_id',
		'completed_datetime',
		'progress',
		'last_viewed'
	];

	public function user()
	{
		return $this->belongsTo(User::class, 'student_id');
	}

	public function lesson()
	{
		return $this->belongsTo(Lesson::class);
	}
}
