<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class QdrantService
{
    protected string $url;

    public function __construct()
    {
        $this->url = config('qdrant.url');
    }

    public function upsert(
        string $collection,
        array $vector,
        array $payload
    ): void {
        Http::put(
            "{$this->url}/collections/{$collection}/points?wait=true",
            [
                'points' => [[
                    'id' => uniqid(),
                    'vector' => $vector,
                    'payload' => $payload
                ]]
            ]
        );
    }
}
