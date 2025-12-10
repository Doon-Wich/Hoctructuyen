<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Laravel\Sanctum\PersonalAccessToken;

class CheckTokenExpiration
{
    public function handle(Request $request, Closure $next)
    {
        $token = $request->bearerToken();
        Log::info('Token: ' . $token);

        try {
            if ($token) {
                $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);
                Log::info('AccessToken: ', ['token' => $accessToken]);

                if ($accessToken && $accessToken->expires_at && $accessToken->expires_at->isPast()) {
                    $accessToken->delete();
                    return response()->json([
                        'status' => 'error',
                        'message' => 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
                    ], 401);
                }
            }
        } catch (\Throwable $e) {
            Log::error('Middleware error: ' . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Middleware error: ' . $e->getMessage(),
            ], 500);
        }

        return $next($request);
    }
}
