<?php

namespace App\Services;

use Smalot\PdfParser\Parser;

class DocumentTextExtractorService
{
    public function extract(string $path, string $mime): string
    {
        $fullPath = storage_path('app/public/' . $path);

        return match ($mime) {
            'application/pdf' => $this->fromPdf($fullPath),
            'text/plain', 'text/markdown' => file_get_contents($fullPath),
            default => '',
        };
    }

    private function fromPdf(string $path): string
    {
        $parser = new Parser();
        $pdf = $parser->parseFile($path);
        return $pdf->getText();
    }
}
