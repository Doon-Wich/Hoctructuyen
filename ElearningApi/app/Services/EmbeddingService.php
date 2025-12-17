<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class EmbeddingService
{
    protected string $url;

    public function __construct()
    {
        $this->url = 'http://127.0.0.1:11434/api/embeddings';
    }

    public function embed(string $text): array
    {
        $text = trim($text);
        if ($text === '') {
            throw new \Exception('Empty text, skip embedding');
        }

        $response = Http::post('http://127.0.0.1:11434/api/embeddings', [
            'model' => config('ollama.embed_model'),
            'prompt' => $text,
        ]);

        if (!$response->successful()) {
            throw new \Exception('Embedding failed: ' . $response->body());
        }

        $vector = $response->json('embedding');

        if (!is_array($vector) || count($vector) === 0) {
            throw new \Exception(
                'Embedding returned empty vector: ' . $response->body()
            );
        }

        return $vector;
    }
}
