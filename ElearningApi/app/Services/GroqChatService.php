<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class GroqChatService
{
    protected string $apiKey;
    protected string $model;
    protected string $url = 'https://api.groq.com/openai/v1/chat/completions';

    public function __construct()
    {
        $this->apiKey = config('services.groq.api_key');
        $this->model  = config('services.groq.chat_model');

        if (!$this->apiKey) {
            throw new \Exception('GROQ_API_KEY not configured');
        }
    }

    public function chat(string $prompt): string
    {
        $response = Http::timeout(120)
            ->withToken($this->apiKey)
            ->post($this->url, [
                'model' => $this->model,
                'messages' => [
                    [
                        'role' => 'system',
                        'content' => 'Bạn là trợ lý học tập AI, chỉ trả lời bằng tiếng Việt.'
                    ],
                    [
                        'role' => 'user',
                        'content' => $prompt
                    ],
                ],
                'temperature' => 0.2,
                'max_tokens' => 500,
            ]);

        if (!$response->successful()) {
            throw new \Exception($response->body());
        }

        return $response->json('choices.0.message.content') ?? '';
    }
}
