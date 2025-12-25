"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import axios from "@/utils/axios";
import { useRouter } from "next/navigation";
import { Dropdown, Badge } from "antd";
import { BellOutlined } from "@ant-design/icons";
import Notifications from "@/components/Notifications";

export default function Header() {
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    const fetchUnread = async () => {
      try {
        const res = await axios.get("/api/notifications");
        const unread = res.data.data.filter((n) => !n.read_status).length;
        setUnreadCount(unread);
      } catch (err) {
        console.error(err);
        message.error("Không thể tải thông báo");
      }
    };

    fetchUnread();
  }, []);

  const notificationsMenu = {
    items: [
      {
        key: "notifications",
        label: <Notifications onUnreadCountChange={setUnreadCount} />,
      },
    ],
  };

  useEffect(() => {
    const mobileNavToggleBtn = document.querySelector(".mobile-nav-toggle");

    function mobileNavToggle() {
      document.body.classList.toggle("mobile-nav-active");
      mobileNavToggleBtn?.classList.toggle("bi-list");
      mobileNavToggleBtn?.classList.toggle("bi-x");
    }

    if (mobileNavToggleBtn) {
      mobileNavToggleBtn.addEventListener("click", mobileNavToggle);
    }

    return () => {
      if (mobileNavToggleBtn) {
        mobileNavToggleBtn.removeEventListener("click", mobileNavToggle);
      }
    };
  }, []);

  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const token = localStorage.getItem("token");
    setIsLoggedIn(!!token);
  }, []);

  const handleLogouts = async () => {
    try {
      await axios.post("/api/logout");
    } catch (error) {
      console.error("Logout error:", error);
    } finally {
      localStorage.removeItem("token");
      localStorage.removeItem("user");
      setIsLoggedIn(false);
      router.push("/auth/login");
    }
  };

  return (
    <header id="header" className="header d-flex align-items-center sticky-top">
      <div className="container-fluid container-xl position-relative d-flex align-items-center">
        <Link href="/" className="logo d-flex align-items-center me-auto">
          <h1 className="sitename">Elearning</h1>
        </Link>

        <nav id="navmenu" className="navmenu">
          <ul></ul>
          <i className="mobile-nav-toggle d-xl-none bi bi-list"></i>
        </nav>

        <div className="d-flex align-items-center gap-3">
          {isLoggedIn && (
            <Dropdown
              menu={notificationsMenu}
              trigger={["click"]}
              placement="bottomRight"
            >
              <Badge dot={unreadCount > 0}>
                <BellOutlined style={{ fontSize: 24, cursor: "pointer" }} />
              </Badge>
            </Dropdown>
          )}

          {!isLoggedIn ? (
            <Link className="btn-getstarted" href="/auth/login">
              Đăng nhập
            </Link>
          ) : (
            <div
              className="btn-getstarted cursor-pointer"
              onClick={handleLogouts}
            >
              Đăng xuất
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
