<?php

use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\LessonController;
use App\Http\Controllers\Api\ModuleController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\RoleController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Http\Controllers\Api\SanctumController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\LessonTrackingController;
use App\Http\Middleware\CheckTokenExpiration;

// Auth routes
Route::post('/register', [SanctumController::class, 'register'])->name('api.register');
Route::post('/login', [SanctumController::class, 'login'])->name('api.login');
Route::post('/logout', [SanctumController::class, 'logout'])->middleware('auth:sanctum');

// VNPAY callback
Route::get('/vnpay/callback', [PaymentController::class, 'vnpayCallback']);
// Protected route — check token expiration
Route::middleware(['auth:sanctum', CheckTokenExpiration::class])->get('/user', function (Request $request) {
    return response()->json($request->user());
});

Route::middleware(['auth:sanctum', CheckTokenExpiration::class])->group(function () {
    // Khoá học
    Route::resource('courses', CourseController::class);
    Route::get('/get-courses-by-slug/{slug}', [CourseController::class, 'showBySlug']);
    Route::get('/user-purchased-courses', [CourseController::class, 'purchasedCourses']);


    Route::resource('categories', CategoryController::class);
    Route::resource('module', ModuleController::class);

    // Bài học
    Route::resource('lessons', LessonController::class);
    Route::get('get-lesson-by-module/{moduleId}', [LessonController::class, 'getByModule']);

    //User
    Route::resource('users', UserController::class);

    //Vai trò
    Route::resource('roles', RoleController::class);

    //Mua khoá học
    Route::post('/purchase-course', [PaymentController::class, 'purchaseCourse']);
    Route::get('/check-order-status', [PaymentController::class, 'checkOrderStatus']);

    //Theo dõi tiến độ học
    Route::post('/lesson-tracking/update', [LessonTrackingController::class, 'updateProgress']);
    Route::get('/lesson-tracking/get/{lesson_id}', [LessonTrackingController::class, 'getTracking']);
});
