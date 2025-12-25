<?php

namespace App\Http\Controllers\Api;

use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends BaseResourceController
{
    protected $model = Notification::class;
    protected $with = ['user'];

    public function index(Request $request)
    {
        $userId = Auth::id();
        $data = $this->model::with($this->with)
            ->where('user_id', $userId)
            ->orderBy('id', 'desc')
            ->get();

        return $this->statusResponse(200, 200, '', $data);
    }

    public function markAsRead($id)
    {
        $notification = $this->model::where('id', $id)
            ->where('user_id', Auth::id())
            ->first();

        if (!$notification) {
            return $this->statusResponse(200, 404, 'Không tìm thấy thông báo', '');
        }

        $notification->read_status = true;
        $notification->save();

        return $this->statusResponse(200, 200, 'Đã đánh dấu là đã đọc', $notification);
    }

    public function markAllAsRead()
    {
        $this->model::where('user_id', Auth::id())
            ->update(['read_status' => true]);

        return $this->statusResponse(200, 200, 'Đã đánh dấu tất cả thông báo là đã đọc', '');
    }

    public function unread()
    {
        $userId = Auth::id();
        $data = $this->model::with($this->with)
            ->where('user_id', $userId)
            ->where('read_status', false)
            ->orderBy('id', 'desc')
            ->get();

        return $this->statusResponse(200, 200, '', $data);
    }

    protected function getStoreValidationRules()
    {
        return [
            'user_id' => 'required|exists:users,id',
            'message' => 'required|string',
            'read_status' => 'nullable|boolean',
        ];
    }
}
