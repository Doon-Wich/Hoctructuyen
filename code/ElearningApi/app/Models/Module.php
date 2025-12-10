<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Module
 * 
 * @property int $id
 * @property int $course_id
 * @property string $name
 * @property int|null $number
 * 
 * @property Course $course
 * @property Collection|Lesson[] $lessons
 *
 * @package App\Models
 */
class Module extends Model
{
	protected $table = 'module';
	public $timestamps = false;

	protected $casts = [
		'course_id' => 'int',
		'number' => 'int'
	];

	protected $fillable = [
		'course_id',
		'name',
		'number'
	];

	public function course()
	{
		return $this->belongsTo(Course::class);
	}

	public function lessons()
	{
		return $this->hasMany(Lesson::class);
	}
}
