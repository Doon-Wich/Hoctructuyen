<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Discussion
 * 
 * @property int $id
 * @property int $course_id
 * @property int $user_id
 * @property string $content
 * @property Carbon|null $created_at
 * 
 * @property Course $course
 * @property User $user
 * @property Collection|Comment[] $comments
 *
 * @package App\Models
 */
class Discussion extends Model
{
	protected $table = 'discussion';
	public $timestamps = false;

	protected $casts = [
		'course_id' => 'int',
		'user_id' => 'int'
	];

	protected $fillable = [
		'course_id',
		'user_id',
		'content'
	];

	public function course()
	{
		return $this->belongsTo(Course::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function comments()
	{
		return $this->hasMany(Comment::class);
	}
}
