<?php

use App\Http\Controllers\Api\AssignmentsController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\CourseController;
use App\Http\Controllers\Api\DocumentController;
use App\Http\Controllers\Api\FileUploadController;
use App\Http\Controllers\Api\LessonController;
use App\Http\Controllers\Api\ModuleController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\RoleController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Http\Controllers\Api\SanctumController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\LessonTrackingController;
use App\Http\Controllers\Api\QuizAttemptController;
use App\Http\Controllers\Api\QuizController;
use App\Http\Controllers\Api\StudentAssignmentController;
use App\Http\Controllers\Api\TeacherAssignmentController;
use App\Http\Middleware\CheckTokenExpiration;
use App\Models\Role;

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
    // Upload
    Route::post('/upload-file', [FileUploadController::class, 'upload']);

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

    //Bài tập
    Route::resource('/assignments', AssignmentsController::class);
    Route::resource('/student-assignment-submissions', StudentAssignmentController::class);
    Route::get('/student-assignment-submissions/{id}/get', [StudentAssignmentController::class, 'getByAssignment']);

    Route::get('/assignments/submissions/{assignmentId}', [TeacherAssignmentController::class, 'submissions']);
    Route::post('/assignments/submissions/{submissionId}/grade', [TeacherAssignmentController::class, 'grade']);

    //Bài kiểm tra
    Route::resource("/quiz", QuizController::class);

    Route::get('/quiz/{quizId}/get-questions', [QuizController::class, 'getQuestions']);
    Route::post('/quiz/{quizId}/questions', [QuizController::class, 'storeQuestion']);
    Route::put('/questions/{questionId}/update', [QuizController::class, 'updateQuestion']);
    Route::delete('/questions/{id}/delete', [QuizController::class, 'deleteQuestion']);

    //Nộp bài
    Route::post('/quiz/{quizId}/submit', [QuizAttemptController::class, 'submit']);
    Route::get('/quiz/{quiz}/attempt', [QuizAttemptController::class, 'getAttempt']);

    //Upload tài liệu
    Route::get('/documents', [DocumentController::class, 'store']);
});
