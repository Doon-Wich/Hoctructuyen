<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class Payment
 * 
 * @property int $id
 * @property int $order_id
 * @property string|null $payment_method
 * @property string|null $payment_status
 * @property string|null $transaction_id
 * 
 * @property Order $order
 *
 * @package App\Models
 */
class Payment extends Model
{
	protected $table = 'payments';
	public $timestamps = false;

	protected $casts = [
		'order_id' => 'int'
	];

	protected $fillable = [
		'order_id',
		'payment_method',
		'payment_status',
		'transaction_id'
	];

	public function order()
	{
		return $this->belongsTo(Order::class);
	}
}
