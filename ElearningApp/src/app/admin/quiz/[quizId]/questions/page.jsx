"use client";

import { useState, useEffect } from "react";
import { useParams } from "next/navigation";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  Radio,
  Space,
  Popconfirm,
  message,
} from "antd";
import "@ant-design/v5-patch-for-react-19";
import axios from "@/utils/axios";

export default function QuestionManagerPage() {
  const [questions, setQuestions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [editingQuestionId, setEditingQuestionId] = useState(null);
  const [correctAnswer, setCorrectAnswer] = useState(null);
  const [form] = Form.useForm();
  const params = useParams();
  const quizId = params.quizId;

  useEffect(() => {
    if (quizId) fetchQuestions();
  }, [quizId]);

  if (!quizId) return null;

  const fetchQuestions = async () => {
    setLoading(true);
    try {
      const res = await axios.get(`/api/quiz/${quizId}/get-questions`);
      setQuestions(Array.isArray(res.data.data) ? res.data.data : []);
    } catch (e) {
      message.error("Không thể tải danh sách câu hỏi");
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (values) => {
    if (correctAnswer === null) {
      message.error("Vui lòng chọn đáp án đúng");
      return;
    }

    try {
      const answers = values.answers.map((item, index) => ({
        answer_text: item,
        is_correct: index === correctAnswer,
      }));

      if (isEditing) {
        await axios.put(`/api/questions/${editingQuestionId}/update`, {
          question_title: values.question_title,
          answers,
        });
        message.success("Cập nhật câu hỏi thành công!");
      } else {
        await axios.post(`/api/quiz/${quizId}/questions`, {
          question_title: values.question_title,
          answers,
        });
        message.success("Thêm câu hỏi thành công!");
      }

      setIsModalOpen(false);
      form.resetFields();
      setCorrectAnswer(null);
      setIsEditing(false);
      setEditingQuestionId(null);
      fetchQuestions();
    } catch (e) {
      message.error("Lỗi khi lưu câu hỏi");
      console.log(e);
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/api/questions/${id}/delete`);
      message.success("Đã xóa câu hỏi!");
      fetchQuestions();
    } catch (error) {
      message.error("Không thể xóa câu hỏi!");
    }
  };

  const columns = [
    { title: "ID", dataIndex: "id" },
    {
      title: "Câu hỏi",
      dataIndex: "question_title",
    },
    {
      title: "Đáp án",
      render: (_, record) => (
        <div>
          {record.quiz_answers?.map((ans, idx) => (
            <div key={idx} style={{ display: "flex", gap: 8 }}>
              <Radio checked={ans.is_correct} disabled />
              <span>{ans.answer_text}</span>
            </div>
          ))}
        </div>
      ),
    },
    {
      title: "Hành động",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              form.setFieldsValue({
                question_title: record.question_title,
                answers: record.quiz_answers.map((a) => a.answer_text),
              });
              const correctIdx = record.quiz_answers.findIndex(
                (a) => a.is_correct
              );
              setCorrectAnswer(correctIdx);
              setIsEditing(true);
              setEditingQuestionId(record.id);
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Xóa câu hỏi này?"
            onConfirm={() => handleDelete(record.id)}
          >
            <Button danger type="link">
              Xóa
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <h1 style={{ fontSize: 24, marginBottom: 16 }}>
        Quản lý câu hỏi — Quiz {quizId}
      </h1>

      <Button
        type="primary"
        style={{ marginBottom: 16 }}
        onClick={() => {
          form.resetFields();
          setCorrectAnswer(null);
          setIsEditing(false);
          setEditingQuestionId(null);
          setIsModalOpen(true);
        }}
      >
        + Thêm câu hỏi
      </Button>

      <Table
        dataSource={Array.isArray(questions) ? questions : []}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{ pageSize: 5 }}
      />

      <Modal
        title={isEditing ? "Sửa câu hỏi" : "Thêm câu hỏi"}
        open={isModalOpen}
        onCancel={() => {
          setIsModalOpen(false);
          form.resetFields();
          setCorrectAnswer(null);
        }}
        onOk={() => form.submit()}
        okText={isEditing ? "Cập nhật" : "Lưu"}
        cancelText="Hủy"
      >
        <Form
          form={form}
          preserve={false}
          layout="vertical"
          onFinish={handleSubmit}
        >
          <Form.Item
            name="question_title"
            label="Nội dung câu hỏi"
            rules={[{ required: true, message: "Nhập nội dung câu hỏi" }]}
          >
            <Input.TextArea rows={2} />
          </Form.Item>

          <Form.Item label="Các đáp án (ít nhất 4)">
            <Form.Item
              validateStatus={correctAnswer === null ? "error" : ""}
              help={correctAnswer === null ? "Vui lòng chọn đáp án đúng" : ""}
              style={{ marginBottom: 8 }}
            />

            <Form.List name="answers" initialValue={["", "", "", ""]}>
              {(fields) => (
                <>
                  {fields.map((field, index) => {
                    const { key, ...restField } = field;

                    return (
                      <div
                        key={key}
                        style={{
                          display: "flex",
                          gap: 10,
                          marginBottom: 10,
                          alignItems: "center",
                        }}
                      >
                        <Radio
                          checked={correctAnswer === index}
                          onChange={() => setCorrectAnswer(index)}
                        />

                        <Form.Item
                          {...restField}
                          style={{ flex: 1, marginBottom: 0 }}
                          rules={[
                            {
                              required: true,
                              message: "Không để trống đáp án",
                            },
                          ]}
                        >
                          <Input placeholder={`Đáp án ${index + 1}`} />
                        </Form.Item>
                      </div>
                    );
                  })}
                </>
              )}
            </Form.List>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
