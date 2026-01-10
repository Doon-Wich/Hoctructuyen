<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\Course;
use App\Models\OrderItem;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class CourseController extends BaseResourceController
{
    protected $model = Course::class;
    protected $title = 'Khóa học';
    protected $with = ['user', 'category', 'modules.lessons'];

    public function index(Request $request)
    {
        $userId = Auth::id();
        $data = $this->model::with($this->with)
            ->where('teacher_id', $userId)
            ->orderBy('id', 'desc')
            ->get();

        return parent::statusResponse(200, 200, '', $data);
    }

    public function getCourse(Request $request)
    {
        $data = $this->model::with($this->with)
            ->orderBy('id', 'desc')
            ->get();

        return parent::statusResponse(200, 200, '', $data);
    }

    protected function getStoreValidationRules()
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'nullable|numeric|min:0',
            'is_progress_limited' => 'boolean',
            'category_id' => 'required|integer',
        ];
    }

    protected function getUpdateValidationRules($id)
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'nullable|numeric|min:0',
            'is_progress_limited' => 'boolean',
            'category_id' => 'required|integer',
        ];
    }

    public function store(Request $request)
    {
        $rules = $this->getStoreValidationRules();
        $validated = !empty($rules) ? $request->validate($rules) : $request->all();

        $validated['teacher_id'] = Auth::id();
        $validated['slug'] = $this->generateUniqueSlug($validated['name']);

        $course = $this->model::create($validated);

        return parent::statusResponse(200, 200, 'Tạo mới thành công', $course);
    }

    public function update(Request $request, $id)
    {
        $course = $this->model::findOrFail($id);
        $rules = $this->getUpdateValidationRules($id);
        $validated = $request->validate($rules);

        if (isset($validated['name']) && $validated['name'] !== $course->name) {
            $validated['slug'] = $this->generateUniqueSlug($validated['name'], $id);
        }

        $course->update($validated);

        return parent::statusResponse(200, 200, 'Cập nhật thành công', $course);
    }

    public function showBySlug($slug)
    {
        $userId = Auth::id();

        $course = $this->model::with([
            'modules.lessons' => function ($q) {
                $q->orderBy('course_order', 'asc');
            }
        ])->where('slug', $slug)->first();

        if (!$course) {
            return parent::statusResponse(404, 404, 'Khóa học không tồn tại', null);
        }

        $learnedLessonIds = \App\Models\StudentLesson::where('student_id', $userId)
            ->pluck('lesson_id')
            ->toArray();

        // ✅ Gom toàn bộ bài học của khóa (giữ thứ tự toàn khóa học)
        $allLessons = $course->modules->flatMap(function ($module) {
            return $module->lessons;
        })->sortBy('course_order')->values();

        // ✅ Duyệt toàn bộ để gán khóa/mở
        foreach ($allLessons as $index => $lesson) {
            if ($index === 0) {
                $lesson->is_locked = false; // bài đầu tiên mở
            } else {
                $prevLesson = $allLessons[$index - 1];
                $prevCompleted = in_array($prevLesson->id, $learnedLessonIds);
                $lesson->is_locked = !$prevCompleted;
            }

            // Nếu đã học rồi thì mở khóa
            if (in_array($lesson->id, $learnedLessonIds)) {
                $lesson->is_locked = false;
            }
        }

        // ✅ Cập nhật lại flag vào từng module
        foreach ($course->modules as $module) {
            foreach ($module->lessons as $lesson) {
                $lessonData = $allLessons->firstWhere('id', $lesson->id);
                $lesson->is_locked = $lessonData->is_locked ?? true;
            }
        }

        return parent::statusResponse(200, 200, '', $course);
    }



    protected function generateUniqueSlug($name, $ignoreId = null)
    {
        $slug = Str::slug($name);
        $original = $slug;
        $i = 1;

        while ($this->model::where('slug', $slug)
            ->when($ignoreId, fn($q) => $q->where('id', '!=', $ignoreId))
            ->exists()
        ) {
            $slug = $original . '-' . $i++;
        }

        return $slug;
    }

    public function purchasedCourses()
    {
        $user = Auth::user();

        $courseIds = OrderItem::whereHas('order', function ($q) use ($user) {
            $q->where('user_id', $user->id)
                ->where('status', 'paid');
        })->pluck('course_id');

        return response()->json([
            'course_ids' => $courseIds
        ]);
    }
}
