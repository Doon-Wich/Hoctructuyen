<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Enrolment
 * 
 * @property int $course_id
 * @property int $student_id
 * @property Carbon|null $enrolment_datetime
 * @property Carbon|null $completed_datetime
 * 
 * @property Course $course
 * @property User $user
 *
 * @package App\Models
 */
class Enrolment extends Model
{
	protected $table = 'enrolment';
	public $incrementing = false;
	public $timestamps = false;

	protected $casts = [
		'course_id' => 'int',
		'student_id' => 'int',
		'enrolment_datetime' => 'datetime',
		'completed_datetime' => 'datetime'
	];

	protected $fillable = [
		'enrolment_datetime',
		'completed_datetime'
	];

	public function course()
	{
		return $this->belongsTo(Course::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class, 'student_id');
	}
}
