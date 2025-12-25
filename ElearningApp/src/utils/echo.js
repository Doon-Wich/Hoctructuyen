"use client";

import Echo from "laravel-echo";
import Pusher from "pusher-js";

let echo = null;

export function getEcho() {
  if (!echo && typeof window !== "undefined") {
    window.Pusher = Pusher;

    echo = new Echo({
      broadcaster: "pusher",
      key: process.env.NEXT_PUBLIC_PUSHER_APP_KEY,
      cluster: process.env.NEXT_PUBLIC_PUSHER_APP_CLUSTER,
      forceTLS: true,
    });
  }

  return echo;
}
