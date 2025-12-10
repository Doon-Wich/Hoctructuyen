<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TeamInvitation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;

class SanctumController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'device_name' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email hoặc mật khẩu không chính xác.',
            ], 401);
        }

        $user->tokens()->delete();

        $tokenResult = $user->createToken($request->device_name, ['*'], now()->addHours(2));
        $token = $tokenResult->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Đăng nhập thành công',
            'token' => $token,
            'user' => $user,
        ]);
    }

    public function register(Request $request)
    {
        $request->validate(
            [
                'full_name' => 'required|string|max:100',
                'email' => 'required|email|unique:users,email',
                'password' => 'required|min:6|confirmed',
                'role_id' => 'nullable|integer|exists:roles,id',
                'device_name' => 'required',
            ],
            [
                'full_name.required' => 'Vui lòng nhập họ và tên.',
                'email.required' => 'Vui lòng nhập địa chỉ email.',
                'email.email' => 'Địa chỉ email không hợp lệ.',
                'email.unique' => 'Email này đã được sử dụng.',
                'password.required' => 'Vui lòng nhập mật khẩu.',
                'password.min' => 'Mật khẩu phải có ít nhất :min ký tự.',
                'password.confirmed' => 'Xác nhận mật khẩu không khớp.',
                'device_name.required' => 'Thiếu thông tin thiết bị (device_name).',
            ]
        );



        $user = User::create([
            'role_id' => $request->role_id ?? 2,
            'full_name' => $request->full_name,
            'email' => strtolower($request->email),
            'password' => Hash::make($request->password),
            'status' => 1,
            'avatar' => $request->avatar ?? null,
        ]);

        $tokenResult = $user->createToken($request->device_name, ['*'], now()->addHours(2));
        $token = $tokenResult->plainTextToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Đăng ký tài khoản thành công',
            'user' => $user,
            'token' => $token,
        ]);
    }


    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Đăng xuất thành công',
        ]);
    }
}
