"use client";
import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  InputNumber,
  Switch,
  Space,
  Popconfirm,
  message,
  Select,
} from "antd";
import "@ant-design/v5-patch-for-react-19";
import axios from "@/utils/axios";
import ModuleManager from "./components/ModuleManager";

export default function CoursePage() {
  const [courses, setCourses] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isModuleModalOpen, setIsModuleModalOpen] = useState(false);
  const [selectedCourseId, setSelectedCourseId] = useState(null);
  const [editingCourse, setEditingCourse] = useState(null);
  const [form] = Form.useForm();

  const fetchCourses = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/courses");

      let data = [];
      if (Array.isArray(res.data)) data = res.data;
      else if (res.data && Array.isArray(res.data.data)) data = res.data.data;

      setCourses(data || []);
    } catch (error) {
      console.error(error);
      message.error("Lỗi khi tải danh sách khóa học");
      setCourses([]);
    } finally {
      setLoading(false);
    }
  };

  const fetchCategories = async () => {
    try {
      const res = await axios.get("/api/categories");
      if (Array.isArray(res.data)) setCategories(res.data);
      else if (res.data && Array.isArray(res.data.data))
        setCategories(res.data.data);
    } catch (error) {
      console.error("Không thể tải danh mục:", error);
    }
  };

  useEffect(() => {
    fetchCourses();
    fetchCategories();
  }, []);

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();

      if (editingCourse) {
        await axios.put(`/api/courses/${editingCourse.id}`, values);
        message.success("Cập nhật khóa học thành công!");
      } else {
        await axios.post("/api/courses", values);
        message.success("Thêm khóa học thành công!");
      }

      form.resetFields();
      setIsModalOpen(false);
      setEditingCourse(null);
      fetchCourses();
    } catch (error) {
      console.error(error);
      message.error("Lưu thất bại, kiểm tra dữ liệu!");
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/api/courses/${id}`);
      message.success("Đã xóa khóa học!");
      fetchCourses();
    } catch (error) {
      message.error("Không thể xóa khóa học!");
    }
  };

  const openModuleModal = (courseId) => {
    setSelectedCourseId(courseId);
    setIsModuleModalOpen(true);
  };

  const columns = [
    { title: "ID", dataIndex: "id", key: "id" },
    { title: "Tên khóa học", dataIndex: "name", key: "name" },
    { title: "Mô tả", dataIndex: "description", key: "description" },
    {
      title: "Danh mục",
      dataIndex: ["category", "name"],
      key: "category",
      render: (_, record) => record?.category?.name || "—",
    },
    {
      title: "Giá",
      dataIndex: "price",
      key: "price",
      render: (price) => `${price || 0} đ`,
    },
    {
      title: "Giới hạn tiến độ",
      dataIndex: "is_progress_limited",
      key: "is_progress_limited",
      render: (v) => (v ? "Có" : "Không"),
    },
    {
      title: "Chương",
      key: "modules",
      render: (_, record) => (
        <Button type="link" onClick={() => openModuleModal(record.id)}>
          Quản lý chương
        </Button>
      ),
    },

    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              setEditingCourse(record);
              form.setFieldsValue({
                ...record,
                category_id: record?.category?.id,
              });
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Xóa khóa học này?"
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
    <>
      <ModuleManager
        open={isModuleModalOpen}
        onClose={() => setIsModuleModalOpen(false)}
        courseId={selectedCourseId}
      />

      <div style={{ padding: 24 }}>
        <h1 style={{ fontSize: 24, marginBottom: 16 }}> Quản lý khóa học</h1>
        <Button
          type="primary"
          style={{ marginBottom: 16 }}
          onClick={() => {
            form.resetFields();
            setEditingCourse(null);
            setIsModalOpen(true);
          }}
        >
          + Thêm khóa học
        </Button>

        <Table
          dataSource={courses || []}
          columns={columns}
          rowKey="id"
          loading={loading}
          pagination={{ pageSize: 5 }}
        />

        <Modal
          title={editingCourse ? "Sửa khóa học" : "Thêm khóa học"}
          open={isModalOpen}
          onCancel={() => {
            setIsModalOpen(false);
            setEditingCourse(null);
            form.resetFields();
          }}
          onOk={() => form.submit()}
          okText="Lưu"
          cancelText="Hủy"
        >
          <Form form={form} layout="vertical" onFinish={handleSubmit}>
            <Form.Item
              name="name"
              label="Tên khóa học"
              rules={[
                { required: true, message: "Vui lòng nhập tên khóa học" },
              ]}
            >
              <Input placeholder="Ví dụ: Lập trình React từ cơ bản đến nâng cao" />
            </Form.Item>

            <Form.Item
              name="description"
              label="Mô tả"
              extra="Mô tả ngắn gọn nội dung và mục tiêu của khóa học"
              rules={[
                { required: true, message: "Vui lòng nhập mô tả khóa học" },
                { max: 500, message: "Mô tả không được vượt quá 500 ký tự" },
              ]}
            >
              <Input.TextArea
                rows={3}
                placeholder="Khóa học giúp học viên nắm vững kiến thức nền tảng và thực hành..."
              />
            </Form.Item>

            <Form.Item
              name="category_id"
              label="Danh mục"
              extra="Danh mục giúp phân loại và tìm kiếm khóa học dễ dàng hơn"
              rules={[{ required: true, message: "Vui lòng chọn danh mục" }]}
            >
              <Select
                placeholder="Chọn danh mục khóa học"
                options={categories.map((c) => ({
                  label: c.name,
                  value: c.id,
                }))}
              />
            </Form.Item>

            <Form.Item
              name="price"
              label="Giá (VNĐ)"
              extra="Nhập 0 nếu khóa học miễn phí"
              rules={[
                { required: true, message: "Vui lòng nhập giá khóa học" },
                { type: "number", min: 0, message: "Giá phải là số không âm" },
              ]}
            >
              <InputNumber
                min={0}
                style={{ width: "100%" }}
                placeholder="Ví dụ: 500000"
              />
            </Form.Item>

            <Form.Item
              name="is_progress_limited"
              label="Giới hạn tiến độ"
              extra="Bật để học viên phải hoàn thành từng chương theo thứ tự"
              valuePropName="checked"
            >
              <Switch />
            </Form.Item>
          </Form>
        </Modal>
      </div>
    </>
  );
}
