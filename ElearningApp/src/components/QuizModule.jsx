"use client";

import { useEffect, useState } from "react";
import axios from "@/utils/axios";
import { Button, message, Radio, Space, Badge } from "antd";
import "@ant-design/v5-patch-for-react-19";

export default function QuizModule({ quizId }) {
  const [quiz, setQuiz] = useState(null);
  const [loading, setLoading] = useState(true);
  const [answers, setAnswers] = useState({}); 
  const [currentPage, setCurrentPage] = useState(1);
  const [attempt, setAttempt] = useState(null); 
  const questionsPerPage = 10;

  useEffect(() => {
    const fetchQuiz = async () => {
      try {
        const res = await axios.get(`/api/quiz/${quizId}`);
        setQuiz(res.data.data);

  
        const attemptRes = await axios.get(`/api/quiz/${quizId}/attempt`);
        if (attemptRes.data.data) {
          setAttempt(attemptRes.data.data); 
          message.info("Bạn đã hoàn thành bài kiểm tra này!");
        }
      } catch (err) {
        console.error(err);
        message.error("Không thể tải bài kiểm tra!");
      } finally {
        setLoading(false);
      }
    };
    fetchQuiz();
  }, [quizId]);

  if (loading) return <p>Đang tải bài kiểm tra...</p>;
  if (!quiz) return <p>Không tìm thấy bài kiểm tra!</p>;

  if (attempt) {
    return (
      <div className="p-4">
        <h3>{quiz.name}</h3>
        <p>
          Điểm của bạn: {attempt.score}/{100} -{" "}
          {attempt.passed ? "Đạt" : "Không đạt"}
        </p>
        <Button
          type="primary"
          onClick={() => {
            window.location.href = `/`;
          }}
        >
          Quay lại khóa học
        </Button>
      </div>
    );
  }

  const startIndex = (currentPage - 1) * questionsPerPage;
  const endIndex = startIndex + questionsPerPage;
  const currentQuestions = quiz.quiz_questions.slice(startIndex, endIndex);
  const totalPages = Math.ceil(quiz.quiz_questions.length / questionsPerPage);

  const handleSelectAnswer = (questionId, answerId) => {
    setAnswers((prev) => ({ ...prev, [questionId]: answerId }));
  };

  const handleSubmit = async () => {
    if (!quiz) return;

    try {
      const res = await axios.post(`/api/quiz/${quiz.id}/submit`, {
        answers,
      });

      const { score, total, passed } = res.data.data;

      message.success(
        `Bạn đã nộp bài! Điểm: ${score}/${total}. ${passed ? "Đạt" : "Không đạt"}`
      );

      setAttempt({ score, total, passed });
    } catch (err) {
      console.error(err);
      message.error("Không thể nộp bài, thử lại!");
    }
  };

  return (
    <div className="d-flex p-4 gap-4" style={{ minHeight: "80vh" }}>
      <div className="flex-grow-1">
        <h3 style={{ marginBottom: "1.5rem" }}>{quiz.name}</h3>

        {currentQuestions.map((q, idx) => (
          <div
            key={q.id}
            id={`question-${q.id}`}
            className="mb-4 p-4 border rounded shadow-sm bg-white"
          >
            <p>
              <strong>
                Câu {startIndex + idx + 1}: {q.question_title}
              </strong>
            </p>
            <Radio.Group
              onChange={(e) => handleSelectAnswer(q.id, e.target.value)}
              value={answers[q.id]}
            >
              <Space direction="vertical">
                {q.quiz_answers.map((a) => (
                  <Radio key={a.id} value={a.id}>
                    {a.answer_text}
                  </Radio>
                ))}
              </Space>
            </Radio.Group>
          </div>
        ))}

        <div className="d-flex justify-content-between align-items-center mt-4">
          <div>
            {Array.from({ length: totalPages }, (_, i) => (
              <Button
                key={i + 1}
                type={currentPage === i + 1 ? "primary" : "default"}
                className="me-2"
                onClick={() => setCurrentPage(i + 1)}
              >
                Trang {i + 1}
              </Button>
            ))}
          </div>
          {currentPage === totalPages && (
            <Button type="primary" size="large" onClick={handleSubmit}>
              Nộp bài
            </Button>
          )}
        </div>
      </div>
      
      <div
        className="p-3 border rounded bg-light"
        style={{
          minWidth: "200px",
          maxHeight: "80vh",
          overflowY: "auto",
        }}
      >
        <h5 className="mb-3">Câu hỏi</h5>
        <div className="d-flex flex-wrap gap-2">
          {quiz.quiz_questions.map((q, idx) => {
            const answered = answers[q.id];
            return (
              <Badge
                key={q.id}
                dot={answered ? true : false}
                color={answered ? "#52c41a" : undefined}
              >
                <Button
                  size="small"
                  type={
                    currentQuestions.find((cq) => cq.id === q.id)
                      ? "primary"
                      : "default"
                  }
                  onClick={() => {
                    const page = Math.floor(idx / questionsPerPage) + 1;
                    setCurrentPage(page);
                    setTimeout(() => {
                      const el = document.getElementById(`question-${q.id}`);
                      if (el)
                        el.scrollIntoView({
                          behavior: "smooth",
                          block: "start",
                        });
                    }, 100);
                  }}
                >
                  {idx + 1}
                </Button>
              </Badge>
            );
          })}
        </div>
      </div>
    </div>
  );
}
