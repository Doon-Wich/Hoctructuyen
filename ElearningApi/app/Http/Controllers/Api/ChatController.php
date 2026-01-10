<?php

namespace App\Http\Controllers\Api;

use App\Events\ChatMessageSent;
use App\Http\Controllers\Controller;
use App\Services\EmbeddingService;
use App\Services\GroqChatService;
use App\Services\QdrantService;
use App\Services\RagPromptService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class ChatController extends Controller
{
    public function chat(
        Request $request,
        EmbeddingService $embedding,
        QdrantService $qdrant,
        RagPromptService $promptService,
        GroqChatService $nroq
    ) {
        $question = trim($request->input('question'));
        $lessonId = $request->input('lessonId');

        $queryVector = $embedding->embed($question);

        $results = $qdrant->search(
            'course_documents',
            $queryVector,
            3,
            [
                'must' => [[
                    'key' => 'lesson_id',
                    'match' => ['value' => $lessonId]
                ]]
            ]
        );

        $llmContext = collect($results)
            ->pluck('payload.text')
            ->map(fn($t) => $this->cleanText($t))
            ->filter(fn($t) => mb_strlen($t) > 120)
            ->take(2)
            ->map(function ($t) {
                $t = mb_substr($t, 0, 450);

                if (preg_match('/^(.+?[\.!\?])\s/su', $t, $m)) {
                    return $m[1];
                }

                return $t;
            })
            ->implode("\n\n");


        $hasContext = !empty($results) && mb_strlen($llmContext) >= 50;

        if (!$hasContext) {
            $answer = "Mình chưa tìm thấy nội dung phù hợp trong bài học cho câu hỏi này.";
        } else {
            $prompt = $promptService->build($question, $llmContext);
            $answer = $nroq->chat($prompt);
        }
        event(new ChatMessageSent([
            'question' => $question,
            'answer'   => $answer
        ]));

        return response()->json([
            'question' => $question,
            'answer'   => $answer,
        ]);
    }

    private function cleanText(string $text): string
    {
        $patterns = [
            '/Downloaded by.*?\n/i',
            '/Scan to open.*?\n/i',
            '/lOMoARcPSD\|\d+/i',
        ];

        $text = preg_replace($patterns, '', $text);
        $text = preg_replace('/\s+/', ' ', $text);

        return trim($text);
    }
}
