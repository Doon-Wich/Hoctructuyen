<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Lesson
 * 
 * @property int $id
 * @property int $module_id
 * @property string $name
 * @property int|null $number
 * @property string|null $video_url
 * @property string|null $lesson_details
 * @property int|null $course_order
 * @property int|null $duration
 * 
 * @property Module $module
 * @property Collection|LessonTracking[] $lesson_trackings
 * @property Collection|StudentLesson[] $student_lessons
 *
 * @package App\Models
 */
class Lesson extends Model
{
	protected $table = 'lesson';
	public $timestamps = false;

	protected $casts = [
		'module_id' => 'int',
		'number' => 'int',
		'course_order' => 'int',
		'duration' => 'int'
	];

	protected $fillable = [
		'module_id',
		'name',
		'number',
		'video_url',
		'lesson_details',
		'course_order',
		'duration'
	];

	public function module()
	{
		return $this->belongsTo(Module::class);
	}

	public function lesson_trackings()
	{
		return $this->hasMany(LessonTracking::class);
	}

	public function student_lessons()
	{
		return $this->hasMany(StudentLesson::class);
	}
}
