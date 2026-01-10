"use client";
import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  Space,
  Popconfirm,
  message,
} from "antd";
import "@ant-design/v5-patch-for-react-19";
import axios from "@/utils/axios";

export default function CategoryPage() {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState(null);
  const [form] = Form.useForm();

  const fetchCategories = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/categories");

      let data = [];
      if (Array.isArray(res.data)) data = res.data;
      else if (res.data && Array.isArray(res.data.data))
        data = res.data.data;

      setCategories(data || []);
    } catch (error) {
      console.error(error);
      message.error("Không thể tải danh sách danh mục");
      setCategories([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();

      if (editingCategory) {
        await axios.put(`/api/categories/${editingCategory.id}`, values);
        message.success("Cập nhật danh mục thành công!");
      } else {
        await axios.post("/api/categories", values);
        message.success("Thêm danh mục mới thành công!");
      }

      form.resetFields();
      setIsModalOpen(false);
      setEditingCategory(null);
      fetchCategories();
    } catch {
      message.error("Lưu thất bại, vui lòng kiểm tra dữ liệu!");
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/api/categories/${id}`);
      message.success("Đã xóa danh mục!");
      fetchCategories();
    } catch {
      message.error("Không thể xóa danh mục!");
    }
  };

  const columns = [
    { title: "ID", dataIndex: "id", key: "id", width: 80 },
    { title: "Tên danh mục", dataIndex: "name", key: "name" },
    { title: "Mô tả", dataIndex: "description", key: "description" },
    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              setEditingCategory(record);
              form.setFieldsValue(record);
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Bạn có chắc chắn muốn xóa danh mục này?"
            okText="Xóa"
            cancelText="Hủy"
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
      <h1 style={{ fontSize: 24, marginBottom: 8 }}>
        Quản lý danh mục khóa học
      </h1>
      <p style={{ color: "#666", marginBottom: 16 }}>
        Danh mục dùng để phân loại các khóa học trong hệ thống
      </p>

      <Button
        type="primary"
        style={{ marginBottom: 16 }}
        onClick={() => {
          form.resetFields();
          setEditingCategory(null);
          setIsModalOpen(true);
        }}
      >
        + Thêm danh mục
      </Button>

      <Table
        dataSource={categories || []}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{ pageSize: 5 }}
      />

      <Modal
        title={editingCategory ? "Sửa danh mục" : "Thêm danh mục"}
        open={isModalOpen}
        onCancel={() => {
          setIsModalOpen(false);
          setEditingCategory(null);
          form.resetFields();
        }}
        onOk={() => form.submit()}
        okText="Lưu"
        cancelText="Hủy"
      >
        <Form form={form} layout="vertical" onFinish={handleSubmit}>
          <Form.Item
            name="name"
            label="Tên danh mục"
            extra="Tên hiển thị của danh mục trong hệ thống"
            rules={[
              { required: true, message: "Vui lòng nhập tên danh mục" },
              {
                max: 100,
                message: "Tên danh mục không được vượt quá 100 ký tự",
              },
            ]}
          >
            <Input placeholder="Ví dụ: Lập trình Web, AI, Backend..." />
          </Form.Item>

          <Form.Item
            name="description"
            label="Mô tả"
            extra="Mô tả ngắn gọn về danh mục (không bắt buộc)"
            rules={[
              {
                max: 500,
                message: "Mô tả không được vượt quá 500 ký tự",
              },
            ]}
          >
            <Input.TextArea
              rows={3}
              placeholder="Nhập mô tả cho danh mục (nếu có)"
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
