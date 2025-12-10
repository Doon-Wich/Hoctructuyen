<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Order
 * 
 * @property int $id
 * @property int $user_id
 * @property float $total_amount
 * @property string|null $status
 * @property Carbon|null $created_at
 * 
 * @property User $user
 * @property Collection|OrderItem[] $order_items
 * @property Collection|Payment[] $payments
 *
 * @package App\Models
 */
class Order extends Model
{
	protected $table = 'orders';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'total_amount' => 'float'
	];

	protected $fillable = [
		'user_id',
		'total_amount',
		'status'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function order_items()
	{
		return $this->hasMany(OrderItem::class);
	}

	public function payments()
	{
		return $this->hasMany(Payment::class);
	}
}
