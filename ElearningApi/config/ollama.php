<?php

return [
    'ollama_url' => env('OLLAMA_URL', 'http://127.0.0.1:11434'),
    'embed_model' => env('OLLAMA_EMBED_MODEL', 'nomic-embed-text'),
];
