<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class LessonTracking
 * 
 * @property int $id
 * @property int $student_id
 * @property int $lesson_id
 * @property int|null $last_position
 * @property int|null $total_watched_time
 * @property int|null $progress_percent
 * @property bool|null $is_completed
 * @property Carbon|null $last_viewed
 * 
 * @property User $user
 * @property Lesson $lesson
 *
 * @package App\Models
 */
class LessonTracking extends Model
{
	protected $table = 'lesson_tracking';
	public $timestamps = false;

	protected $casts = [
		'student_id' => 'int',
		'lesson_id' => 'int',
		'last_position' => 'int',
		'total_watched_time' => 'int',
		'progress_percent' => 'int',
		'is_completed' => 'bool',
		'last_viewed' => 'datetime'
	];

	protected $fillable = [
		'student_id',
		'lesson_id',
		'last_position',
		'total_watched_time',
		'progress_percent',
		'is_completed',
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
