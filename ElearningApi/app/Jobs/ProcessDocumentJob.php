<?php

namespace App\Jobs;

use App\Services\EmbeddingService;
use App\Services\QdrantService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

class ProcessDocumentJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public function __construct(
        protected int $documentId,
        protected string $rawText
    ) {}

    public function handle(
        EmbeddingService $embeddingService,
        QdrantService $qdrant
    ) {
        // 1. Chunk
        $chunks = $this->chunkText($this->rawText);

        foreach ($chunks as $index => $chunk) {

            // 2. Embed chunk (MiniLM)
            $vector = $embeddingService->embed($chunk);

            // 3. Save vector -> Qdrant
            $qdrant->upsert(
                collection: 'documents',
                vector: $vector,
                payload: [
                    'document_id' => $this->documentId,
                    'chunk_index' => $index,
                    'text' => $chunk,
                ]
            );
        }
    }

    private function chunkText(string $text): array
    {
        $chunkSize = 400;

        $words = explode(' ', $text);
        $chunks = array_chunk($words, $chunkSize);

        return array_map(function ($chunk) {
            return implode(' ', $chunk);
        }, $chunks);
    }
}
