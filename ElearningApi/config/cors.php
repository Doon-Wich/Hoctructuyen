<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Đây là cấu hình CORS cho phép các request từ FE (Next.js, React…)
    | truy cập vào BE Laravel. Bạn có thể tùy chỉnh allowed origins, headers…
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie', 'broadcasting/auth'],

    'allowed_methods' => ['*'], // cho phép tất cả phương thức GET, POST, PUT, DELETE…

    'allowed_origins' => ['http://localhost:3000'], // domain của FE

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'], // cho phép tất cả header

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true, // nếu dùng cookie hoặc Sanctum token
];
