<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Broadcast;

class BroadcastServiceProvider extends ServiceProvider
{
    public function boot()
    {
        // Nếu toàn bộ public channel, có thể bỏ dòng dưới
        // Broadcast::routes(['middleware' => ['auth:sanctum']]);

        // Nếu vẫn dùng private/presence channel khác
        require base_path('routes/channels.php');
    }
}
