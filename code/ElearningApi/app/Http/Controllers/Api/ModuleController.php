<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseResourceController;
use Illuminate\Http\Request;
use App\Models\Module;

class ModuleController extends BaseResourceController
{
    protected $model = Module::class;
    protected $title = 'Chương học';
    protected $with = ['course', 'lessons'];

    public function index(Request $request)
    {
        $query = $this->model::with($this->with)->orderBy('number', 'asc');

        if ($request->has('course_id')) {
            $query->where('course_id', $request->course_id);
        }

        $data = $query->get();

        return parent::statusResponse(200, 200, 'Thành công', $data);
    }

    protected function getStoreValidationRules()
    {
        return [
            'course_id' => 'required|integer|exists:course,id',
            'name' => 'required|string|max:255',
            'number' => 'nullable|integer|min:1',
        ];
    }

    protected function getUpdateValidationRules($id)
    {
        return [
            'course_id' => 'required|integer|exists:course,id',
            'name' => 'required|string|max:255',
            'number' => 'nullable|integer|min:1',
        ];
    }
}
