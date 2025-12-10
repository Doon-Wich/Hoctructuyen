"use client";

import { useEffect, useState } from "react";
import { Table, Button, Modal, Form, Input, message, InputNumber } from "antd";
import axios from "@/utils/axios";
import dayjs from "dayjs";
import CodeEditor from "@/components/CodeEditor";

export default function AssignmentManagerPage() {
  const [assignments, setAssignments] = useState([]);
  const [loading, setLoading] = useState(false);

  const [gradingModalOpen, setGradingModalOpen] = useState(false);
  const [gradingSubmission, setGradingSubmission] = useState(null);
  const [codeContent, setCodeContent] = useState("");

  const [submissions, setSubmissions] = useState([]);
  const [selectedAssignment, setSelectedAssignment] = useState(null);

  const [form] = Form.useForm();

  const fetchAssignments = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/assignments");
      setAssignments(res.data.data || []);
    } catch (err) {
      console.error(err);
      message.error("Không thể tải danh sách bài tập");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAssignments();
  }, []);

  const viewSubmissions = async (assignment) => {
    try {
      const res = await axios.get(
        `/api/assignments/submissions/${assignment.id}`
      );
      setSubmissions(res.data.data || []);
      setSelectedAssignment(assignment);
    } catch (err) {
      console.error(err);
      message.error("Không thể tải danh sách nộp bài");
    }
  };

  const openGradingModal = (submission) => {
    setGradingSubmission(submission);

    let parsedCode = "";
    try {
      parsedCode = submission?.content
        ? JSON.parse(submission.content).text
        : "";
    } catch {
      parsedCode = "";
    }
    setCodeContent(parsedCode);

    let teacherFeedback = "";
    if (submission?.teacher_feedback) {
      const parts = submission.teacher_feedback.split(
        "/* Nhận xét giáo viên */"
      );
      teacherFeedback = parts[1]?.trim() || "";
    }

    form.setFieldsValue({
      score: submission.score,
      teacher_feedback: teacherFeedback,
    });

    setGradingModalOpen(true);
  };

  const handleGradingSubmit = async () => {
    try {
      const values = await form.validateFields();

      await axios.post(
        `/api/assignments/submissions/${gradingSubmission.id}/grade`,
        {
          score: Number(values.score),
          teacher_feedback: values.teacher_feedback, 
          content: codeContent, 
        }
      );

      message.success("Chấm điểm thành công!");

      const res = await axios.get(
        `/api/assignments/submissions/${gradingSubmission.assignment_id}`
      );
      setSubmissions(res.data.data || []);

      setGradingModalOpen(false);
      setGradingSubmission(null);
      setCodeContent("");
      form.resetFields();
    } catch (err) {
      console.error(err);
      message.error("Chấm điểm thất bại");
    }
  };

  const assignmentColumns = [
    { title: "ID", dataIndex: "id", key: "id" },
    { title: "Tên bài tập", dataIndex: "title", key: "title" },
    { title: "Mô tả", dataIndex: "description", key: "description" },
    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Button type="link" onClick={() => viewSubmissions(record)}>
          Xem bài nộp
        </Button>
      ),
    },
  ];

  const submissionColumns = [
    { title: "Học sinh", dataIndex: ["student", "name"], key: "student" },
    {
      title: "Nộp lúc",
      dataIndex: "submitted_at",
      key: "submitted_at",
      render: (text) => dayjs(text).format("DD/MM/YYYY HH:mm"),
    },
    {
      title: "File",
      dataIndex: "file_url",
      key: "file",
      render: (url) =>
        url ? (
          <a href={url} target="_blank" rel="noreferrer">
            Download
          </a>
        ) : (
          "—"
        ),
    },
    {
      title: "Nội dung",
      dataIndex: "content",
      key: "content",
      render: (_, record) => (
        <Button type="link" onClick={() => openGradingModal(record)}>
          Xem & Chấm điểm
        </Button>
      ),
    },
    {
      title: "Điểm",
      dataIndex: "score",
      key: "score",
      render: (s) => s ?? "—",
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <h1>Quản lý bài tập</h1>

      <Table
        dataSource={assignments}
        columns={assignmentColumns}
        rowKey="id"
        loading={loading}
        pagination={{ pageSize: 5 }}
      />

      <Modal
        title={`Bài nộp: ${selectedAssignment?.title}`}
        open={!!selectedAssignment}
        onCancel={() => setSelectedAssignment(null)}
        footer={null}
        width={900}
      >
        <Table
          dataSource={submissions}
          columns={submissionColumns}
          rowKey="id"
          pagination={{ pageSize: 5 }}
        />
      </Modal>

      <Modal
        title={`Chấm điểm: ${gradingSubmission?.student.name}`}
        open={gradingModalOpen}
        onCancel={() => setGradingModalOpen(false)}
        width={1200}
        styles={{
          body: { height: "500px", display: "flex", flexDirection: "column" },
        }}
        footer={null}
      >
        <div style={{ display: "flex", gap: 24, flex: 1, minHeight: 0 }}>
          <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
            <h5>Bài làm học sinh</h5>
            <CodeEditor
              value={codeContent}
              readOnly
              theme="tokyo"
              style={{ flex: 1, minHeight: 0 }}
            />
          </div>

          <div style={{ flex: 1, display: "flex", flexDirection: "column" }}>
            <h5>Chấm điểm & Nhận xét</h5>
            <CodeEditor
              value={
                gradingSubmission?.teacher_feedback ||
                `/* Bài làm học sinh */\n${codeContent}\n\n/* Nhận xét giáo viên */\n`
              }
              onChange={(val) => form.setFieldsValue({ teacher_feedback: val })}
              theme="tokyo"
              style={{ flex: 1, minHeight: 0 }}
            />
          </div>
        </div>
        <div
          style={{
            marginTop: 16,
            display: "flex",
            flexDirection: "column",
            alignItems: "flex-start",
          }}
        >
          <Form form={form} layout="vertical" style={{ width: 250 }}>
            <Form.Item
              name="score"
              label="Điểm"
              rules={[{ required: true, message: "Nhập điểm" }]}
            >
              <InputNumber min={0} max={100} style={{ width: "100%" }} />
            </Form.Item>

            <Form.Item name="teacher_feedback" style={{ display: "none" }}>
              <Input />
            </Form.Item>
          </Form>
        </div>

        <div
          style={{
            marginTop: 16,
            display: "flex",
            flexDirection: "column",
            alignItems: "flex-end",
          }}
        >
          <div style={{ display: "flex", gap: 8 }}>
            <Button onClick={() => setGradingModalOpen(false)}>Hủy</Button>
            <Button type="primary" onClick={handleGradingSubmit}>
              Lưu
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}
