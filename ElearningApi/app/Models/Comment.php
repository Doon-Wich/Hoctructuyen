<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Comment
 * 
 * @property int $id
 * @property int $discussion_id
 * @property int $user_id
 * @property string $content
 * @property Carbon|null $created_at
 * 
 * @property Discussion $discussion
 * @property User $user
 *
 * @package App\Models
 */
class Comment extends Model
{
	protected $table = 'comment';
	public $timestamps = false;

	protected $casts = [
		'discussion_id' => 'int',
		'user_id' => 'int'
	];

	protected $fillable = [
		'discussion_id',
		'user_id',
		'content'
	];

	public function discussion()
	{
		return $this->belongsTo(Discussion::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}
