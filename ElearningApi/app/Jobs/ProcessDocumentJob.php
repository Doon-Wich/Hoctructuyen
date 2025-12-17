<?php

namespace App\Jobs;

use App\Models\Document;
use App\Services\PdfRagIngestService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

class ProcessDocumentJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    protected int $documentId;

    public function __construct(int $documentId)
    {
        $this->documentId = $documentId;
    }

    public function handle(PdfRagIngestService $ingest)
    {
        $document = Document::findOrFail($this->documentId);
        $ingest->ingest($document);
    }
}
