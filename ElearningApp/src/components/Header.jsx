"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import axios from "@/utils/axios";
import { useRouter } from "next/navigation";

export default function Header() {
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
          <ul>
            {/* <li>
              <a href="index.html" className="active">
                Home
                <br />
              </a>
            </li>
            <li>
              <a href="about.html">About</a>
            </li>
            <li>
              <a href="courses.html">Courses</a>
            </li>
            <li>
              <a href="trainers.html">Trainers</a>
            </li>
            <li>
              <a href="events.html">Events</a>
            </li>
            <li>
              <a href="pricing.html">Pricing</a>
            </li>
            <li className="dropdown">
              <a href="#">
                <span>Dropdown</span>{" "}
                <i className="bi bi-chevron-down toggle-dropdown"></i>
              </a>
              <ul>
                <li>
                  <a href="#">Dropdown 1</a>
                </li>
                <li className="dropdown">
                  <a href="#">
                    <span>Deep Dropdown</span>{" "}
                    <i className="bi bi-chevron-down toggle-dropdown"></i>
                  </a>
                  <ul>
                    <li>
                      <a href="#">Deep Dropdown 1</a>
                    </li>
                    <li>
                      <a href="#">Deep Dropdown 2</a>
                    </li>
                    <li>
                      <a href="#">Deep Dropdown 3</a>
                    </li>
                    <li>
                      <a href="#">Deep Dropdown 4</a>
                    </li>
                    <li>
                      <a href="#">Deep Dropdown 5</a>
                    </li>
                  </ul>
                </li>
                <li>
                  <a href="#">Dropdown 2</a>
                </li>
                <li>
                  <a href="#">Dropdown 3</a>
                </li>
                <li>
                  <a href="#">Dropdown 4</a>
                </li>
              </ul>
            </li>
            <li>
              <a href="contact.html">Contact</a>
            </li> */}
          </ul>
          <i className="mobile-nav-toggle d-xl-none bi bi-list"></i>
        </nav>

        {!isLoggedIn ? (
          <Link className="btn-getstarted" href="/auth/login">
            Đăng nhập
          </Link>
        ) : (
          <div className="btn-getstarted cursor-pointer" onClick={handleLogouts}>
            Đăng xuất
          </div>
        )}
      </div>
    </header>
  );
}
