<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Course
 * 
 * @property int $id
 * @property int $teacher_id
 * @property string $name
 * @property string|null $description
 * @property float|null $price
 * @property bool|null $is_progress_limited
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Category $category
 * @property User $user
 * @property Collection|Discussion[] $discussions
 * @property Collection|Enrolment[] $enrolments
 * @property Collection|Module[] $modules
 * @property Collection|OrderItem[] $order_items
 * @property Collection|Quiz[] $quizzes
 *
 * @package App\Models
 */
class Course extends Model
{
	protected $table = 'course';

	protected $casts = [
		'teacher_id' => 'int',
		'price' => 'float',
		'is_progress_limited' => 'bool',
		'category_id' => 'int',
		'slug' => 'string'
	];

	protected $fillable = [
		'teacher_id',
		'name',
		'description',
		'price',
		'is_progress_limited',
		'category_id',
		'slug'
	];

	public function user()
	{
		return $this->belongsTo(User::class, 'teacher_id');
	}

	public function category()
	{
		return $this->belongsTo(Category::class, 'category_id');
	}

	public function discussions()
	{
		return $this->hasMany(Discussion::class);
	}

	public function enrolments()
	{
		return $this->hasMany(Enrolment::class);
	}

	public function modules()
	{
		return $this->hasMany(Module::class);
	}

	public function order_items()
	{
		return $this->hasMany(OrderItem::class);
	}

	public function quizzes()
	{
		return $this->hasMany(Quiz::class);
	}
	
}
