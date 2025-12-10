<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ActivityLog
 * 
 * @property int $id
 * @property int $user_id
 * @property string $action
 * @property string|null $ip_address
 * @property Carbon|null $created_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class ActivityLog extends Model
{
	protected $table = 'activity_log';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int'
	];

	protected $fillable = [
		'user_id',
		'action',
		'ip_address'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}
