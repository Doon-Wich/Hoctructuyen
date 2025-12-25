<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AISolveController extends Controller
{
    public function fixAssignment(Request $request)
    {
        $prompt = <<<PROMPT
Bạn là một giáo viên lập trình.

Đề bài:
{$request->title}
Mô tả đề bài:
{$request->description}

Bài làm của học sinh:
{$request->content}

NHIỆM VỤ:
- Kiểm tra và sửa bài làm của học sinh

QUY TẮC XỬ LÝ:
1. Nếu bài làm KHÔNG phải là một chương trình hoàn chỉnh
   → Viết lại thành MỘT CHƯƠNG TRÌNH HOÀN CHỈNH phù hợp với đề bài
2. Nếu bài làm ĐÃ là chương trình hoàn chỉnh
   → Sửa lỗi và tối ưu nhưng GIỮ NGUYÊN Ý TƯỞNG
3. Code trả về PHẢI:
   - Biên dịch được
   - Chạy đúng yêu cầu đề bài
   - Không thêm chức năng ngoài đề bài
4. Không được chỉ sửa một dòng đơn lẻ khi đề bài yêu cầu chương trình

ĐỊNH DẠNG TRẢ VỀ (BẮT BUỘC – KHÔNG ĐƯỢC THÊM DÒNG KHÁC):
1. BÀI CHỮA
   - Chỉ chứa code, KHÔNG được thêm dòng chú thích hay note nào khác
2. GIẢI THÍCH
   - Giải thích ngắn gọn hoàn toàn bằng TIẾNG VIỆT:
     + Bài làm ban đầu sai ở đâu
     + Đã sửa những gì
QUAN TRỌNG: Chỉ trả về đúng hai phần trên, KHÔNG thêm dòng, note hay nhãn nào khác.
PROMPT;

        $res = Http::post(
            rtrim(config('ollama.ollama_url'), '/') . '/api/generate',
            [
                'model' => config('ollama.chat_model'),
                'prompt' => $prompt,
                'stream' => false,
                'options' => [
                    'temperature' => 0.2,
                ],
            ]
        );

        return response()->json([
            'data' => trim($res->json('response') ?? ''),
        ]);
    }
}
