"use client";
import { useState, useEffect } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  message,
  Popconfirm,
  Select,
  Switch,
} from "antd";
import { PlusOutlined, EditOutlined, DeleteOutlined } from "@ant-design/icons";
import axios from "@/utils/axios";
import { useRouter } from "next/navigation";

export default function QuizManager() {
  const [quizzes, setQuizzes] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingQuiz, setEditingQuiz] = useState(null);

  const [form] = Form.useForm();
  const router = useRouter();

  const [courses, setCourses] = useState([]);

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    try {
      const res = await axios.get("/api/courses");
      // Giả sử API trả về data.data
      setCourses(res.data.data || []);
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => {
    fetchQuizzes();
  }, []);

  const fetchQuizzes = async () => {
    setLoading(true);
    try {
      const res = await axios.get("api/quiz");
      setQuizzes(res.data.data || []);
    } catch (err) {
      message.error("Không tải được danh sách quiz!");
    }
    setLoading(false);
  };

  const openAddModal = () => {
    setEditingQuiz(null);
    form.resetFields();
    setIsModalOpen(true);
  };

  const openEditModal = (record) => {
    setEditingQuiz(record);
    form.setFieldsValue(record);
    setIsModalOpen(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      if (editingQuiz) {
        await axios.put(`/api/qui/${editingQuiz.id}`, values);
        message.success("Cập nhật quiz thành công!");
      } else {
        await axios.post("/api/quiz", values);
        message.success("Tạo quiz mới thành công!");
      }
      setIsModalOpen(false);
      fetchQuizzes();
    } catch (err) {
      console.log(err.response?.data || err);
      message.error("Lỗi khi lưu quiz!");
    }
  };

  const deleteQuiz = async (id) => {
    try {
      await axios.delete(`/api/quiz/${id}`);
      message.success("Xóa quiz thành công!");
      fetchQuizzes();
    } catch {
      message.error("Không thể xóa quiz!");
    }
  };

  const columns = [
    {
      title: "ID",
      dataIndex: "id",
      width: 60,
    },
    {
      title: "Tên Quiz",
      dataIndex: "name",
    },
    {
      title: "Mô tả",
      dataIndex: "description",
    },
    {
      title: "Hành động",
      width: 260,
      render: (_, record) => (
        <>
          <Button
            icon={<EditOutlined />}
            type="primary"
            onClick={() => openEditModal(record)}
            style={{ marginRight: 8 }}
          >
            Sửa
          </Button>

          <Button
            onClick={() => router.push(`/admin/quiz/${record.id}/questions`)}
            style={{ marginRight: 8 }}
          >
            Quản lý câu hỏi
          </Button>

          <Popconfirm
            title="Xóa quiz?"
            okText="Xóa"
            cancelText="Hủy"
            onConfirm={() => deleteQuiz(record.id)}
          >
            <Button danger icon={<DeleteOutlined />}>
              Xóa
            </Button>
          </Popconfirm>
        </>
      ),
    },
  ];

  return (
    <div style={{ padding: 20 }}>
      <h2>Quản lí bài kiểm tra</h2>

      <Button
        type="primary"
        icon={<PlusOutlined />}
        onClick={openAddModal}
        style={{ marginBottom: 20 }}
      >
        Thêm bài kiểm tra
      </Button>

      <Table
        loading={loading}
        dataSource={quizzes}
        columns={columns}
        rowKey="id"
        bordered
      />

      <Modal
        open={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        onOk={handleSave}
        okText="Lưu"
        cancelText="Hủy"
        title={editingQuiz ? "Sửa Quiz" : "Thêm Quiz"}
      >
        <Form form={form} layout="vertical">
          <Form.Item
            label="Tên Bài kiểm tra"
            name="name"
            extra="Tên hiển thị cho bài kiểm tra mà học viên sẽ thấy"
            rules={[{ required: true, message: "Nhập tên quiz!" }]}
          >
            <Input placeholder="Ví dụ: Kiểm tra cuối chương 1" />
          </Form.Item>

          <Form.Item
            label="Khóa học"
            name="course_id"
            extra="Chọn khóa học mà bài kiểm tra này thuộc về"
            rules={[{ required: true, message: "Chọn khóa học!" }]}
          >
            <Select placeholder="Chọn khóa học" allowClear>
              {courses.map((course) => (
                <Select.Option key={course.id} value={course.id}>
                  {course.name}
                </Select.Option>
              ))}
            </Select>
          </Form.Item>

          <Form.Item
            label="Số thứ tự"
            name="number"
            extra="Thứ tự hiển thị của bài kiểm tra trong danh sách"
          >
            <Input type="number" placeholder="Ví dụ: 1, 2, 3..." />
          </Form.Item>

          <Form.Item
            label="Thứ tự khóa học"
            name="course_order"
            extra="Dùng để sắp xếp quiz theo tiến trình học"
          >
            <Input type="number" placeholder="Ví dụ: 1" />
          </Form.Item>

          <Form.Item
            label="Điểm tối thiểu"
            name="min_pass_score"
            extra="Điểm tối thiểu để được xem là hoàn thành bài kiểm tra"
          >
            <Input type="number" placeholder="Ví dụ: 70" />
          </Form.Item>

          <Form.Item
            label="Bắt buộc đạt"
            name="is_pass_required"
            extra="Bật nếu học viên bắt buộc phải đạt điểm tối thiểu mới được qua bài tiếp theo"
            valuePropName="checked"
          >
            <Switch />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
