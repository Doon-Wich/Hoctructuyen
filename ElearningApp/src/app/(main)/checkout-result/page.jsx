"use client";
import { useEffect, useState } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import axios from "@/utils/axios";

export default function CheckoutResultPage() {
  const searchParams = useSearchParams();
  const router = useRouter();

  const orderCode = searchParams.get("orderCode");
  const statusFromQuery = searchParams.get("status");
  const [status, setStatus] = useState(statusFromQuery || null);

  useEffect(() => {
    if (!orderCode || statusFromQuery) return; // đã có status thì không cần fetch

    let interval;
    let redirectTimeout;

    const fetchStatus = async () => {
      try {
        const res = await axios.get(`/api/check-order-status?orderCode=${orderCode}`);
        const currentStatus = res.data.status;
        setStatus(currentStatus);

        if (currentStatus === "success") {
          clearInterval(interval); // dừng polling
          const pending = JSON.parse(sessionStorage.getItem("pendingPurchase") || "{}");
          redirectTimeout = setTimeout(() => {
            if (pending.slug && pending.hashId) {
              router.push(`/courses/${pending.slug}?id=${pending.hashId}`);
            } else {
              router.push("/");
            }
            sessionStorage.removeItem("pendingPurchase");
          }, 4000);
        }

        if (currentStatus === "failed") {
          clearInterval(interval); // dừng polling
          redirectTimeout = setTimeout(() => router.push("/"), 4000);
        }
      } catch (err) {
        clearInterval(interval); // dừng polling nếu lỗi
        setStatus("failed");
        redirectTimeout = setTimeout(() => router.push("/"), 4000);
      }
    };

    fetchStatus(); // gọi lần đầu ngay
    interval = setInterval(fetchStatus, 3000); // tiếp tục polling nếu chưa success/failed

    return () => {
      clearInterval(interval);
      clearTimeout(redirectTimeout);
    };
  }, [orderCode, statusFromQuery, router]);

  if (!status) return <p>Đang kiểm tra thanh toán...</p>;

  return (
    <div className="container py-5 text-center">
      {status === "success" && (
        <>
          <h2 className="text-success">Thanh toán thành công!</h2>
          <p className="mt-3">Bạn sẽ được chuyển về khoá học sau vài giây...</p>
        </>
      )}
      {status === "failed" && (
        <>
          <h2 className="text-danger">Thanh toán thất bại hoặc đã hủy!</h2>
          <p className="mt-3">
            Bạn sẽ được chuyển về trang chủ sau vài giây...
          </p>
        </>
      )}
    </div>
  );
}
