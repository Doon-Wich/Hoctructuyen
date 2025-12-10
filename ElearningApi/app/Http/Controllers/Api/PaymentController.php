<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\Course;

class PaymentController extends Controller
{

    public function purchaseCourse(Request $request)
    {
        $user = Auth::user();
        $course = Course::findOrFail($request->course_id);

        DB::beginTransaction();
        try {
            $orderCode = 'HD' . strtoupper(uniqid());

            $order = Order::create([
                'user_id' => $user->id,
                'total_amount' => $course->price,
                'status' => 'pending',
            ]);

            OrderItem::create([
                'order_id' => $order->id,
                'course_id' => $course->id,
                'price' => $course->price
            ]);

            Payment::create([
                'order_id' => $order->id,
                'payment_method' => 'vnpay',
                'payment_status' => 'pending',
                'transaction_id' => $orderCode
            ]);

            DB::commit();

            $vnp_TmnCode = env('VNPAY_TMN_CODE');
            $vnp_HashSecret = env('VNPAY_HASH_SECRET');
            $vnp_Url = env('VNPAY_URL');

            $vnp_TxnRef = $orderCode;
            $vnp_OrderInfo = "Thanh toán khóa học: {$course->name}";
            $vnp_Amount = $course->price * 100;
            $vnp_Locale = "vn";
            $vnp_CurrCode = "VND";
            $vnp_Command = "pay";
            $vnp_IpAddr = $_SERVER['REMOTE_ADDR'];

            $vnp_Returnurl = env('VNPAY_RETURN_URL') . "?orderCode={$orderCode}";

            $inputData = [
                "vnp_Version" => "2.1.0",
                "vnp_TmnCode" => $vnp_TmnCode,
                "vnp_Amount" => $vnp_Amount,
                "vnp_Command" => $vnp_Command,
                "vnp_CreateDate" => date('YmdHis'),
                "vnp_CurrCode" => $vnp_CurrCode,
                "vnp_IpAddr" =>  $vnp_IpAddr,
                "vnp_Locale" => $vnp_Locale,
                "vnp_OrderInfo" => $vnp_OrderInfo,
                "vnp_OrderType" => "other",
                "vnp_ReturnUrl" => $vnp_Returnurl,
                "vnp_TxnRef" => $vnp_TxnRef
            ];

            ksort($inputData);
            $query = "";
            $i = 0;
            $hashdata = "";
            foreach ($inputData as $key => $value) {
                if ($i == 1) {
                    $hashdata .= '&' . urlencode($key) . "=" . urlencode($value);
                } else {
                    $hashdata .= urlencode($key) . "=" . urlencode($value);
                    $i = 1;
                }
                $query .= urlencode($key) . "=" . urlencode($value) . '&';
            }

            $vnp_Url = $vnp_Url . "?" . $query;
            if (isset($vnp_HashSecret)) {
                $vnpSecureHash = hash_hmac('sha512', $hashdata, $vnp_HashSecret);
                $vnp_Url .= 'vnp_SecureHash=' . $vnpSecureHash;
            }

            return response()->json(['vnp_Url' => $vnp_Url]);
        } catch (\Throwable $e) {
            DB::rollBack();
            Log::error('purchaseCourse error: ' . $e->getMessage());
            return response()->json(['message' => 'Lỗi server'], 500);
        }
    }

    public function vnpayCallback(Request $request)
    {
        $vnp_TxnRef = $request->query('vnp_TxnRef'); 
        $vnp_ResponseCode = $request->query('vnp_ResponseCode');

        $payment = Payment::where('transaction_id', $vnp_TxnRef)->first();
        if (!$payment) return response()->json(['message' => 'Order not found'], 404);

        if ($vnp_ResponseCode === '00') {
            $payment->update(['payment_status' => 'success']);
            $payment->order->update(['status' => 'paid']);
        } else {
            $payment->update(['payment_status' => 'failed']);
            $payment->order->update(['status' => 'cancelled']);
        }


        $frontendUrl = "http://localhost:3000/checkout-result?orderCode={$vnp_TxnRef}&status={$payment->payment_status}";
        return redirect($frontendUrl);
    }

    public function checkOrderStatus(Request $request)
    {
        $orderCode = $request->query('orderCode');
        if (!$orderCode) return response()->json(['message' => 'Thiếu orderCode'], 400);

        $payment = Payment::where('transaction_id', $orderCode)->first();
        if (!$payment) return response()->json(['message' => 'Không tìm thấy payment'], 404);

        return response()->json(['status' => $payment->payment_status]);
    }
}
