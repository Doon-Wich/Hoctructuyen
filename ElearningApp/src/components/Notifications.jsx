"use client";

import { useEffect, useState } from "react";
import axios from "@/utils/axios";

export default function Notifications({ onUnreadCountChange }) {
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(false);

  const fetchNotifications = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/notifications");
      const data = res.data.data;
      setNotifications(data);

      // Gửi số lượng thông báo chưa đọc lên component cha (Header)
      const unreadCount = data.filter(n => !n.read_status).length;
      onUnreadCountChange?.(unreadCount);
    } catch (err) {
      console.error(err);
      alert("Không thể tải thông báo");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNotifications();
  }, []);

  const markAsRead = async (id) => {
    try {
      await axios.post(`/api/notifications/mark-read/${id}`);
      setNotifications(prev =>
        prev.map(n => n.id === id ? { ...n, read_status: true } : n)
      );

      const unreadCount = notifications.filter(n => n.id !== id && !n.read_status).length;
      onUnreadCountChange?.(unreadCount);
    } catch (err) {
      console.error(err);
      alert("Không thể đánh dấu đã đọc");
    }
  };

  return (
    <div
      className="bg-light rounded shadow-sm p-2"
      style={{ minWidth: 300, maxHeight: 400, overflowY: 'auto' }}
    >
      {loading ? (
        <div className="text-center py-4">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
        </div>
      ) : notifications.length === 0 ? (
        <div className="text-center py-4 text-muted">Không có thông báo</div>
      ) : (
        <div className="list-group list-group-flush">
          {notifications.map((item, idx) => (
            <button
              key={item.id}
              type="button"
              className={`list-group-item list-group-item-action d-flex justify-content-between align-items-start bg-white`}
              onClick={() => !item.read_status && markAsRead(item.id)}
              style={{
                borderBottom: idx !== notifications.length - 1 ? '1px solid #dee2e6' : 'none',
                borderRadius: '0.25rem',
              }}
            >
              <div className="d-flex align-items-center gap-2">
                {!item.read_status && (
                  <span
                    className="rounded-circle bg-danger"
                    style={{ width: 10, height: 10, display: 'inline-block' }}
                  />
                )}
                <div className="d-flex flex-column">
                  <span>{item.message}</span>
                  <small className="text-muted">{new Date(item.created_at).toLocaleString()}</small>
                </div>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
