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
    <div className="mt-3 p-4 border rounded bg-light position-relative shadow-sm">
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
      </div>

      <h5 className="mb-2">{assignment.title}</h5>
      <p className="mb-3">{assignment.description}</p>

      <div style={{ display: "flex", gap: 16 }}>
        <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
          <label className="fw-bold">Bài làm học sinh:</label>
          <CodeEditor
            value={content}
            onChange={setContent}
            readOnly={isGraded}
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

        <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
          <label className="fw-bold">Nhận xét giáo viên:</label>
          <CodeEditor
            value={submission?.teacher_feedback || ""}
            readOnly
            theme="tokyo"
            style={{ flex: 1, minHeight: 300 }}
          />
        </div>
      </div>

      {!isGraded && (
        <button
          onClick={handleSubmit}
          className="btn btn-primary btn-sm mt-3"
        >
          {isSubmitted ? "Cập nhật bài nộp" : "Nộp bài"}
        </button>
      )}
    </div>
  );
}
