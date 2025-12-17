<?php

namespace App\Services;

use App\Models\Document;
use App\Services\EmbeddingService;
use App\Services\QdrantService;
use App\Services\DocumentTextExtractorService;

class PdfRagIngestService
{
    public function __construct(
        protected EmbeddingService $embedding,
        protected QdrantService $qdrant,
        protected DocumentTextExtractorService $extractor
    ) {}

    public function ingest(Document $document): void
    {
        $rawText = $this->extractor->extract(
            $document->file_path,
            $document->file_type
        );

        $cleanText = $this->cleanText($rawText);
        $chunks = $this->chunkText($cleanText);

        foreach ($chunks as $index => $chunk) {
            $vector = $this->embedding->embed($chunk);

            $this->qdrant->upsert(
                collection: 'course_documents',
                vector: $vector,
                payload: [
                    'document_id' => $document->id,
                    'course_id'   => $document->course_id,
                    'lesson_id'   => $document->lesson_id,
                    'chunk_index' => $index,
                    'text'        => $chunk,
                ]
            );
        }

        $document->update(['status' => 'done']);
    }

    private function chunkText(string $text): array
    {
        $words = preg_split('/\s+/', $text);
        return array_map(
            fn($chunk) => implode(' ', $chunk),
            array_chunk($words, 400)
        );
    }

    private function cleanText(string $text): string
    {
        // bỏ rác PDF phổ biến
        $patterns = [
            '/Downloaded by.*?\n/i',
            '/Studocu.*?\n/i',
            '/Scan to open.*?\n/i',
            '/lOMoARcPSD\|\d+/i',
        ];

        $text = preg_replace($patterns, '', $text);

        // gom khoảng trắng
        $text = preg_replace('/\s+/', ' ', $text);

        return trim($text);
    }
}
