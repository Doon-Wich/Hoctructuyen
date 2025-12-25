"use client";

import { useState, useEffect, useRef } from "react";
import { getEcho } from "@/utils/echo";
import axiosClient from "@/utils/axios";

export default function ChatBox({ lessonId }) {
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState("");
  const messagesEndRef = useRef(null);
  const TYPING_ID = "ai-typing";

  useEffect(() => {
    const echo = getEcho();
    if (!echo) return;

    const channel = echo.channel("chat");

    const handler = (e) => {
      const answer = e?.answer || e?.message?.answer;
      if (!answer) return;

      setMessages((prev) => {
        const withoutTyping = prev.filter((m) => m.id !== TYPING_ID);

        return [
          ...withoutTyping,
          {
            id: crypto.randomUUID(),
            text: answer,
            sender: "ai",
          },
        ];
      });
    };

    channel.listen("ChatMessageSent", handler);

    return () => {
      channel.stopListening("ChatMessageSent", handler);
      echo.leave("chat");
    };
  }, []);

  const sendMessage = async () => {
    if (!input.trim()) return;

    const userText = input;

    setMessages((prev) => [
      ...prev,
      { id: crypto.randomUUID(), text: userText, sender: "user" },
      {
        id: TYPING_ID,
        sender: "ai",
        type: "typing",
      },
    ]);

    setInput("");

    await axiosClient.post("/api/chat", {
      question: userText,
      lessonId,
    });
  };

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  return (
    <div
      className="bg-white rounded-4 shadow d-flex flex-column"
      style={{
        width: "380px",
        height: "500px",
        maxHeight: "60vh",
      }}
    >
      <div className="bg-primary text-white px-3 py-2 rounded-top-4 fw-semibold">
        Hỗ trợ học tập
      </div>
      <div
        className="flex-grow-1 p-3 overflow-auto bg-light d-flex flex-column gap-3"
        style={{ minHeight: 0 }}
      >
        {messages.map((m) => (
          <div
            key={m.id}
            className={`d-flex ${
              m.sender === "user"
                ? "justify-content-end"
                : "justify-content-start"
            }`}
          >
            <div
              className="px-3 py-2 rounded-4 shadow-sm text-break"
              style={{
                maxWidth: m.sender === "user" ? "70%" : "85%",
                backgroundColor: m.sender === "user" ? "#bbf7d0" : "#e5e7eb",
                color: "#111827",
                whiteSpace: "pre-wrap",
                lineHeight: "1.6",
              }}
            >
              {m.type === "typing" ? (
                <div className="d-flex align-items-center px-2 py-1">
                  <div className="typing-dots">
                    <span></span>
                    <span></span>
                    <span></span>
                  </div>
                </div>
              ) : m.sender === "ai" ? (
                <div dangerouslySetInnerHTML={{ __html: m.text }} />
              ) : (
                m.text
              )}
            </div>
          </div>
        ))}

        <div ref={messagesEndRef} />
      </div>

      <div className="d-flex p-3 gap-2 border-top bg-white">
        <input
          type="text"
          className="form-control rounded-pill"
          placeholder="Nhập câu hỏi..."
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && sendMessage()}
        />
        <button
          className="btn btn-primary rounded-pill fw-semibold px-3"
          onClick={sendMessage}
        >
          Gửi
        </button>
      </div>
    </div>
  );
}
