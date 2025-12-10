<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseResourceController;
use Illuminate\Http\Request;
use App\Models\Role;

class RoleController extends BaseResourceController
{
    protected $model = Role::class;
    protected $title = 'Vai trò';

    protected function getStoreValidationRules()
    {
        return [
            'name' => 'required|string|max:255|unique:roles,name',
            'description' => 'nullable|string|max:500',
        ];
    }
    
    protected function getUpdateValidationRules($id)
    {
        return [
            'name' => 'required|string|max:255|unique:roles,name,' . $id,
            'description' => 'nullable|string|max:500',
        ];
    }
}
