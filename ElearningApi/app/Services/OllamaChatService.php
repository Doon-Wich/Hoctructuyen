<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class OllamaChatService
{
    protected string $url;
    protected string $model;

    public function __construct()
    {
        $this->url = rtrim(config('ollama.ollama_url'), '/') . '/api/generate';

        $this->model = config('ollama.chat_model');

        if (!$this->model) {
            throw new \Exception('OLLAMA_CHAT_MODEL is not configured');
        }
    }

    public function chat(string $prompt): string
    {
        $response = Http::timeout(120)
            ->post($this->url, [
                'model' => $this->model,
                'prompt' => $prompt,
                'stream' => false,
            ]);

        if (!$response->successful()) {
            throw new \Exception($response->body());
        }

        return $response->json('response') ?? '';
    }
}
