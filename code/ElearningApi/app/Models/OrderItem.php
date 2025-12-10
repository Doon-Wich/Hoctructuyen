<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class OrderItem
 * 
 * @property int $id
 * @property int $order_id
 * @property int $course_id
 * @property float $price
 * 
 * @property Order $order
 * @property Course $course
 *
 * @package App\Models
 */
class OrderItem extends Model
{
	protected $table = 'order_items';
	public $timestamps = false;

	protected $casts = [
		'order_id' => 'int',
		'course_id' => 'int',
		'price' => 'float'
	];

	protected $fillable = [
		'order_id',
		'course_id',
		'price'
	];

	public function order()
	{
		return $this->belongsTo(Order::class);
	}

	public function course()
	{
		return $this->belongsTo(Course::class);
	}
}
