"use client";

import { useEffect } from "react";

export default function Preloader() {
  useEffect(() => {
    const preloader = document.getElementById("preloader");
    if (preloader) {
      preloader.style.opacity = "0";
      setTimeout(() => {
        preloader.remove();
      }, 500);
    }
  }, []);

  return <div id="preloader"></div>;
}
