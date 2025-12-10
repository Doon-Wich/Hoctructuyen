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
    if (!orderCode) return;

    let interval;
    let timeout;

    const fetchStatus = async () => {
      try {
        const res = await axios.get(
          `/api/check-order-status?orderCode=${orderCode}`
        );
        setStatus(res.data.status);

        if (res.data.status === "success") {
          
          const pending = JSON.parse(
            sessionStorage.getItem("pendingPurchase") || "{}"
          );
          timeout = setTimeout(() => {
            if (pending.slug && pending.hashId) {
              router.push(`/courses/${pending.slug}?id=${pending.hashId}`);
              sessionStorage.removeItem("pendingPurchase"); 
            } else {
              router.push("/"); 
            }
          }, 4000);
        }
      } catch (err) {
        setStatus("failed");
        timeout = setTimeout(() => router.push("/"), 4000);
      }
    };

    if (!statusFromQuery) fetchStatus();
    interval = setInterval(fetchStatus, 3000);

    return () => {
      clearInterval(interval);
      clearTimeout(timeout);
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
