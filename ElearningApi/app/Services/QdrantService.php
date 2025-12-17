<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class QdrantService
{
    protected string $url;

    public function __construct()
    {
        $this->url = config('services.qdrant.url');

        if (!$this->url) {
            throw new \Exception('QDRANT_URL is not configured');
        }
    }

    public function upsert(
        string $collection,
        array $vector,
        array $payload
    ): void {
        logger('Embedding size: ' . count($vector));

        $response = Http::put(
            "{$this->url}/collections/{$collection}/points?wait=true",
            [
                'points' => [[
                    'id' => (string) Str::uuid(),
                    'vector' => $vector,
                    'payload' => $payload
                ]]
            ]
        );

        if (!$response->successful()) {
            throw new \Exception(
                'Qdrant upsert failed: ' . $response->body()
            );
        }
    }

    public function search(
        string $collection,
        array $vector,
        int $limit = 5,
        array $filter = []
    ): array {
        $response = Http::post(
            "{$this->url}/collections/{$collection}/points/search",
            [
                'vector' => $vector,
                'limit' => $limit,
                'with_payload' => true,
                'filter' => $filter
            ]
        );

        return $response->json('result') ?? [];
    }
}
