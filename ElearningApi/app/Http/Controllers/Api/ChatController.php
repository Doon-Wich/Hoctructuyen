<?php

namespace App\Http\Controllers\Api;

use App\Events\ChatMessageSent;
use App\Http\Controllers\Controller;
use App\Services\EmbeddingService;
use App\Services\OllamaChatService;
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
        OllamaChatService $ollama
    ) {
        $question = trim($request->input('question'));
        $lessonId = $request->input('lessonId');
        
        if (preg_match('/^(xin chào|chào|hello|hi)$/iu', $question)) {
            $answer = "Chào bạn. Mình có thể giúp bạn giải đáp nội dung bài học này. Bạn cứ hỏi nhé!";

            event(new ChatMessageSent([
                'question' => $question,
                'answer'   => $answer,
            ]));

            return response()->json([
                'question' => $question,
                'answer'   => $answer,
            ]);
        }


        $queryVector = $embedding->embed($question);

        $results = $qdrant->search(
            'course_documents',
            $queryVector,
            5,
            [
                'must' => [[
                    'key' => 'lesson_id',
                    'match' => ['value' => $lessonId]
                ]]
            ]
        );

        $llmContext = collect($results)
            ->pluck('payload.text')
            ->filter(fn($t) => mb_strlen(trim($t)) > 50)
            ->map(fn($t) => $this->cleanText($t))
            ->unique()
            ->take(3)
            ->map(fn($t) => mb_substr($t, 0, 600))
            ->implode("\n\n");

        if (empty($llmContext)) {
            $answer = "Mình chưa tìm thấy nội dung phù hợp trong tài liệu cho câu hỏi này.";
        } else {
            $prompt = $promptService->build($question, $llmContext);
            $answer = $ollama->chat($prompt);
        }

        $start = microtime(true);

        $answer = $ollama->chat($prompt);
        $afterLLM = microtime(true);

        event(new ChatMessageSent([
            'question' => $question,
            'answer' => $answer
        ]));
        $afterEvent = microtime(true);

        Log::info('Chat Timing', [
            'LLM_time_s' => round($afterLLM - $start, 3),
            'Broadcast_time_s' => round($afterEvent - $afterLLM, 3),
        ]);

        return response()->json([
            'question' => $question,
            'answer'   => $answer,
        ]);
    }

    private function cleanText(string $text): string
    {
        $patterns = [
            '/Downloaded by.*?\n/i',
            '/Studocu.*?\n/i',
            '/Scan to open.*?\n/i',
            '/lOMoARcPSD\|\d+/i',
        ];

        $text = preg_replace($patterns, '', $text);
        $text = preg_replace('/\s+/', ' ', $text);

        return trim($text);
    }
}
