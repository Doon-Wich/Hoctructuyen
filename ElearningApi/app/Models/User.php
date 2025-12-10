<?php

namespace App\Models;

use App\Models\ActivityLog;
use App\Models\Course;
use App\Models\Discussion;
use App\Models\Enrolment;
use App\Models\LessonTracking;
use App\Models\Notification;
use App\Models\Order;
use App\Models\Role;
use App\Models\StudentLesson;
use App\Models\StudentQuizAttempt;
use Dom\Comment;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
	use HasApiTokens, Notifiable;

	protected $table = 'users';

	protected $casts = [
		'role_id' => 'int',
		'status' => 'int'
	];

	protected $hidden = [
		'password'
	];

	protected $fillable = [
		'role_id',
		'full_name',
		'email',
		'password',
		'avatar',
		'status'
	];

	public function role()
	{
		return $this->belongsTo(Role::class);
	}

	public function activity_logs()
	{
		return $this->hasMany(ActivityLog::class);
	}

	public function comments()
	{
		return $this->hasMany(Comment::class);
	}

	public function courses()
	{
		return $this->hasMany(Course::class, 'teacher_id');
	}

	public function discussions()
	{
		return $this->hasMany(Discussion::class);
	}

	public function enrolments()
	{
		return $this->hasMany(Enrolment::class, 'student_id');
	}

	public function lesson_trackings()
	{
		return $this->hasMany(LessonTracking::class, 'student_id');
	}

	public function notifications()
	{
		return $this->hasMany(Notification::class);
	}

	public function orders()
	{
		return $this->hasMany(Order::class);
	}

	public function student_lessons()
	{
		return $this->hasMany(StudentLesson::class, 'student_id');
	}

	public function student_quiz_attempts()
	{
		return $this->hasMany(StudentQuizAttempt::class, 'student_id');
	}
}
