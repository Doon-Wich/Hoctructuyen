<?php

namespace App\Services;

class RagPromptService
{
    public function build(string $question, string $context): string
    {
        return <<<PROMPT
Bạn là trợ lý học tập AI.
BẮT BUỘC trả lời bằng TIẾNG VIỆT.

QUY TẮC:
- Chỉ trả lời trọng tâm bài học trong tài liệu.

NỘI DUNG TÀI LIỆU:
{$context}

CÂU HỎI:
{$question}

CÂU TRẢ LỜI (tiếng Việt, đúng quy tắc trên):
PROMPT;
    }
}
