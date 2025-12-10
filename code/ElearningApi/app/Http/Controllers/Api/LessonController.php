<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\Lesson;
use App\Models\Module;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class LessonController extends BaseResourceController
{
    protected $model = Lesson::class;
    protected $title = 'Bài học';
    protected $with = ['module'];

    protected function getStoreValidationRules()
    {
        return [
            'module_id' => 'required|exists:module,id',
            'name' => 'required|string|max:255',
            'number' => 'nullable|integer|min:1',
            'video_url' => 'nullable|string',
            'lesson_details' => 'nullable|string',
        ];
    }

    protected function getUpdateValidationRules($id)
    {
        return [
            'module_id' => 'required|exists:module,id',
            'name' => 'required|string|max:255',
            'number' => 'nullable|integer|min:1',
            'video_url' => 'nullable|string',
            'lesson_details' => 'nullable|string',
        ];
    }

    public function index(Request $request)
    {
        $query = $this->model::with($this->with)->orderBy('number', 'asc');

        if ($request->has('module_id')) {
            $query->where('module_id', $request->module_id);
        }

        $data = $query->get();

        return parent::statusResponse(200, 200, 'Thành công', $data);
    }

    public function store(Request $request)
    {
        $data = $request->validate($this->getStoreValidationRules());

        $module = Module::findOrFail($data['module_id']);
        $courseId = $module->course_id;

        if (empty($data['number'])) {
            $maxNumber = Lesson::where('module_id', $data['module_id'])->max('number');
            $data['number'] = $maxNumber ? $maxNumber + 1 : 1;
        }

        $maxCourseOrder = Lesson::whereHas('module', function ($q) use ($courseId) {
            $q->where('course_id', $courseId);
        })->max('course_order');

        $data['course_order'] = $maxCourseOrder ? $maxCourseOrder + 1 : 1;

        if (!empty($data['video_url'])) {
            $data['duration'] = $this->getYouTubeDuration($data['video_url']);
        }

        $lesson = Lesson::create($data);

        return $this->statusResponse(201, 201, 'Tạo bài học thành công', $lesson);
    }

    public function update(Request $request, $id)
    {
        $data = $request->validate($this->getUpdateValidationRules($id));

        $lesson = Lesson::findOrFail($id);

        if (!empty($data['video_url'])) {
            $data['duration'] = $this->getYouTubeDuration($data['video_url']);
        }

        $lesson->update($data);

        return $this->statusResponse(200, 200, 'Cập nhật bài học thành công', $lesson);
    }

    private function getYouTubeDuration($url)
    {
        try {
            preg_match('/(?:v=|\/)([0-9A-Za-z_-]{11})(?:\?|&|$)/', $url, $matches);
            if (empty($matches[1])) return null;
            $videoId = $matches[1];

            $apiKey = env('YOUTUBE_API_KEY');
            $apiUrl = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id={$videoId}&key={$apiKey}";

            $response = Http::get($apiUrl);
            $json = $response->json();

            if (empty($json['items'][0]['contentDetails']['duration'])) return null;

            $isoDuration = $json['items'][0]['contentDetails']['duration'];
            return $this->convertYouTubeDurationToSeconds($isoDuration);
        } catch (\Exception $e) {
            Log::error('YouTube API error: ' . $e->getMessage());
            return null;
        }
    }

    private function convertYouTubeDurationToSeconds($duration)
    {
        $interval = new \DateInterval($duration);
        return ($interval->h * 3600) + ($interval->i * 60) + $interval->s;
    }

    public function getByModule($moduleId)
    {
        $lessons = Lesson::where('module_id', $moduleId)
            ->orderBy('number', 'asc')
            ->get();

        return $this->statusResponse(200, 200, 'Danh sách bài học', $lessons);
    }
}
