<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\Category;

class CategoryController extends BaseResourceController
{
    protected $model = Category::class;
    protected $title = 'Danh mục khóa học';
    protected $with = [];

    protected function getStoreValidationRules()
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ];
    }

    protected function getUpdateValidationRules($id)
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ];
    }
}
