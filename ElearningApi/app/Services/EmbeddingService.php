<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class EmbeddingService
{
    public function embed(string $text): array
    {
        $res = Http::post(config('embedding.url').'/embed', [
            'text' => $text
        ]);

        if ($res->failed()) {
            throw new \RuntimeException('Embedding failed');
        }

        return $res->json('embedding');
    }
}
