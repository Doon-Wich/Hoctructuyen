<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Models\UserActivity;
use Illuminate\Support\Str;
use Illuminate\Foundation\Auth\User;
use Illuminate\Support\Facades\Auth;

abstract class BaseResourceController extends Controller
{
    protected $model;
    protected $title;
    protected $with = []; 

    public function index(Request $request)
    {
        $data = $this->model::with($this->with)->orderBy('id', 'desc');
        if (!empty(Auth::user()->unit)) {
            $data = $data->where('to_chuc_id', Auth::user()->to_chuc_id);
        }
        $data = $data->get();
        return parent::statusResponse(200, 200, '', $data);
    }

    public function paginate(Request $request)
    {
        $query = $this->model::with($this->with);

        if ($request->name) {
            $query->where('name', 'like', '%' . $request->name . '%');
        }

        $paginator = $query->orderBy('id', 'desc')->paginate($request->pageSize ?? 15);

        $paginator->getCollection()->transform(function ($item, $key) use ($paginator) {

            $item->stt = $paginator->firstItem() + $key;

            foreach ($this->with as $relation) {
                $relatedData = $item->{$relation};

                if (!$relatedData) {
                    continue;
                }

                $nameField = $relation . '_name';

                if ($relatedData instanceof \Illuminate\Database\Eloquent\Collection) {
                    $item->{$nameField} = $relatedData->pluck('name')->implode(', ');
                } else {
                    $item->{$nameField} = $relatedData->name;
                }
            }
            return $item;
        });

        return $this->statusResponse(200, 200, 'Thành công', $paginator);
    }

    public function generateEmail($name)
    {
        $email = Str::slug($name, '');

        $counter = 1;
        while (User::where('email', $email)->exists()) {
            $email = $email . '-' . $counter;
            $counter++;
        }

        return $email;
    }

    public function store(Request $request)
    {
        $rules = $this->getStoreValidationRules();

        $validated = !empty($rules)
            ? $request->validate($rules)
            : $request->all();

        if (isset($validated['deadline']) && $validated['deadline']) {
            $validated['deadline'] = date('Y-m-d', strtotime($validated['deadline']));
        }

        $this->model::create($validated);

        return parent::statusResponse(200, 200, 'Tạo mới thành công', '');
    }

    public function show(string $id)
    {
        $item = $this->model::with($this->with)->find($id);
        if (!$item) {
            return parent::statusResponse(200, 404, 'Không tìm thấy dữ liệu', '');
        }
        return parent::statusResponse(200, 200, '', $item);
    }

    public function update(Request $request, string $id)
    {

        $item = $this->model::find($id);
        if (!$item) {
            return parent::statusResponse(200, 404, 'Không tìm thấy dữ liệu', '');
        }
 
        $rules = $this->getUpdateValidationRules($id);
     
        $validated = !empty($rules)
            ? $request->validate($rules)
            : $request->all();
        $item->update($validated);


        return parent::statusResponse(200, 200, 'Cập nhật thành công', '');
    }

    public function destroy(string $id)
    {
        $item = $this->model::find($id);
        if (!$item) {
            return parent::statusResponse(200, 404, 'Không tìm thấy dữ liệu', '');
        }

        $itemName = $item->name;

        $item->delete();
        return parent::statusResponse(200, 200, 'Xóa thành công', '');
    }

    protected function getStoreValidationRules()
    {
        return [];
    }

    protected function getUpdateValidationRules($id)
    {
        return [];
    }

    protected function getModuleName()
    {
        $className = class_basename($this);
        $moduleName = str_replace('Controller', '', $className);
        $moduleName = strtolower(preg_replace('/([a-z])([A-Z])/', '$1_$2', $moduleName));
        return $moduleName;
    }
}
