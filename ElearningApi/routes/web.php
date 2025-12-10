<?php

use Illuminate\Support\Facades\Route;


Route::get('/{any}', function () {
    return file_get_contents(public_path('admin/index.html'));
})->where('any', '^(?!api|storage).*');
