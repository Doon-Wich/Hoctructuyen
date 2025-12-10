<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\BaseResourceController;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserController extends BaseResourceController
{
    protected $model = User::class;
    protected $title = 'Người dùng';
    protected $with = ['role'];


    protected function getStoreValidationRules()
    {
        return [
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:6',
            'role_id' => 'required|integer|exists:roles,id',
            'status' => 'nullable|boolean',
        ];
    }

    protected function getUpdateValidationRules($id)
    {
        return [
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id,
            'password' => 'nullable|string|min:6',
            'role_id' => 'required|integer|exists:roles,id',
            'status' => 'nullable|boolean',
        ];
    }

    public function store(Request $request)
    {
        $data = $request->validate($this->getStoreValidationRules());
        $data['password'] = Hash::make($data['password']);
        $this->model::create($data);
        return parent::statusResponse(200, 200, 'Tạo mới người dùng thành công', '');
    }

    public function update(Request $request, string $id)
    {
        $item = $this->model::find($id);
        if (!$item) return parent::statusResponse(200, 404, 'Không tìm thấy người dùng', '');
        
        $data = $request->validate($this->getUpdateValidationRules($id));
        if (!empty($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        } else {
            unset($data['password']);
        }
        $item->update($data);

        return parent::statusResponse(200, 200, 'Cập nhật thành công', '');
    }
}
