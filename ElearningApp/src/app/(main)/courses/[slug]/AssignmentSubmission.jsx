"use client";

import { useEffect, useState } from "react";
import axios from "@/utils/axios";
import { message } from "antd";
import CodeEditor from "@/components/CodeEditor";
import FileUpload from "@/components/FileUpload";
import { AiOutlineCheckCircle, AiOutlineCloseCircle } from "react-icons/ai";

export default function AssignmentSubmission({ lessonId }) {
  const [assignment, setAssignment] = useState(null);
  const [submission, setSubmission] = useState(null);
  const [fileUrl, setFileUrl] = useState("");
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(true);
  const [aiFixedContent, setAiFixedContent] = useState("");
  const [aiLoading, setAiLoading] = useState(false);

  useEffect(() => {
    if (!lessonId) return;

    setAssignment(null);
    setSubmission(null);
    setFileUrl("");
    setContent("");
    setLoading(true);

    const fetchAssignment = async () => {
      try {
        const res = await axios.get(`/api/student-assignment-submissions`, {
          params: { lesson_id: lessonId },
        });

        const assignmentData = res.data?.data?.data?.[0] || null;
        setAssignment(assignmentData);

        if (assignmentData) {
          const resSubmission = await axios.get(
            `/api/student-assignment-submissions/${assignmentData.id}/get`
          );

          const sub = resSubmission.data?.data || {
            content: "",
            file_upload: "",
            submitted_at: null,
            score: null,
            teacher_feedback: null,
          };
          setSubmission(sub);

          if (sub?.content) {
            try {
              const parsed = JSON.parse(sub.content);
              setContent(parsed.text || "");
            } catch {
              setContent("");
            }
          }

          if (sub?.file_upload) {
            setFileUrl(sub.file_upload);
          }
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchAssignment();
  }, [lessonId]);

  const handleSubmit = async () => {
    if (!content && !fileUrl) {
      return message.error("Bạn phải nhập nội dung hoặc upload file");
    }

    if (!assignment) return;

    const payload = {
      assignment_id: assignment.id,
      content: JSON.stringify({ text: content }),
      file_upload: fileUrl || null,
    };

    try {
      await axios.post("/api/student-assignment-submissions", payload);
      message.success("Nộp bài thành công");

      const resSubmission = await axios.get(
        `/api/student-assignment-submissions/${assignment.id}/get`
      );
      setSubmission(resSubmission.data?.data || null);
    } catch (err) {
      console.error(err);
      message.error("Nộp bài thất bại");
    }
  };

  if (loading) return <p>Đang tải bài tập...</p>;
  if (!assignment) return <p>Bài học này chưa có bài tập</p>;

  const isSubmitted = !!submission?.submitted_at;
  const isGraded = !!submission?.teacher_feedback;

  return (
    <div className="mt-3 p-4 pt-5 border rounded bg-light position-relative shadow-sm">
      <div
        className="position-absolute"
        style={{ top: 16, right: 16, textAlign: "right" }}
      >
        {isSubmitted ? (
          <>
            <AiOutlineCheckCircle className="text-success me-1" size={20} />
            <span className="fw-bold">Đã nộp</span>
          </>
        ) : (
          <>
            <AiOutlineCloseCircle className="text-danger me-1" size={20} />
            <span className="fw-bold">Chưa nộp</span>
          </>
        )}
        {isSubmitted && (
          <div className="mt-1">
            <span className="me-2">
              Điểm: {submission.score ?? "Chưa chấm"}
            </span>
          </div>
        )}
        {submission.teacher_feedback && (
          <button
            className="btn btn-warning btn-sm mt-1 me-2 fw-bold shadow-sm px-3 py-2"
            style={{
              background: "linear-gradient(135deg, #ffc107, #ffb300)",
              border: "none",
              fontSize: "0.95rem",
            }}
            disabled={aiLoading || !content}
            onClick={async () => {
              try {
                setAiLoading(true);
                const res = await axios.post("/api/ai/fix-assignment", {
                  title: assignment.title,
                  description: assignment.description,
                  content: content,
                });

                let aiContent = res.data?.data || "";

                aiContent = aiContent.replace(/(.{70,}?)(\s|$)/g, "$1\n");

                setAiFixedContent(aiContent);
                message.success("Đã gợi ý xong");
              } catch {
                message.error("Gợi ý thất bại");
              } finally {
                setAiLoading(false);
              }
            }}
          >
            {aiLoading ? "Đang gợi ý..." : "Gợi ý"}
          </button>
        )}
      </div>

      <h5 className="mb-2">{assignment.title}</h5>
      <p className="mb-3">{assignment.description}</p>

      {submission?.teacher_feedback && (
        <div className="alert alert-info py-2 px-3 mb-3">
          <div className="fw-bold mb-1">Nhận xét của giáo viên:</div>
          <div style={{ whiteSpace: "pre-wrap" }}>
            {submission.teacher_feedback}
          </div>
        </div>
      )}

      <div className="row g-3">
        <div className="col-md-6 d-flex flex-column">
          <label className="fw-bold">Bài làm học sinh:</label>
          <CodeEditor
            value={content}
            onChange={setContent}
            style={{ flex: 1, minHeight: 300 }}
          />
          <div className="mt-2">
            <label className="fw-bold">Tài liệu:</label>
            <FileUpload
              folder="assignments"
              initialValue={fileUrl}
              onChange={setFileUrl}
              disabled={isGraded}
            />
          </div>
        </div>

        {aiFixedContent && (
          <div className="col-md-6 d-flex flex-column">
            <label className="fw-bold">Bài đã được sửa: </label>
            <CodeEditor
              value={aiFixedContent}
              readOnly
              theme="tokyo"
              style={{
                flex: 1,
                minHeight: 300,
                whiteSpace: "pre-wrap",
                wordBreak: "break-word",
              }}
            />
          </div>
        )}
      </div>

      {!isGraded && (
        <button onClick={handleSubmit} className="btn btn-primary btn-sm mt-3">
          {isSubmitted ? "Cập nhật bài nộp" : "Nộp bài"}
        </button>
      )}
    </div>
  );
}
