"use client";
import { useState, useEffect } from "react";
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
import axios from "@/utils/axios";
import LessonManager from "./LessonManager";

export default function ModuleManager({ open, onClose, courseId }) {
  const [modules, setModules] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingModule, setEditingModule] = useState(null);
  const [isLessonModalOpen, setIsLessonModalOpen] = useState(false);
  const [selectedModuleId, setSelectedModuleId] = useState(null);
  const [form] = Form.useForm();

  const fetchModules = async () => {
    if (!courseId) return;
    setLoading(true);
    try {
      const res = await axios.get(`/api/module?course_id=${courseId}`);

      const data = Array.isArray(res?.data?.data)
        ? res.data.data
        : Array.isArray(res?.data)
        ? res.data
        : [];

      if (data.length === 0) {
        console.warn("Không có chương nào được trả về cho course:", courseId);
      }

      setModules(data);
    } catch (err) {
      console.error("Lỗi khi tải danh sách chương:", err);
      message.error("Không thể tải danh sách chương!");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (open && courseId) fetchModules();
  }, [open, courseId]);

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      if (editingModule)
        await axios.put(`/api/module/${editingModule.id}`, values);
      else await axios.post(`/api/module`, { ...values, course_id: courseId });

      message.success("Lưu chương thành công!");
      setIsModalOpen(false);
      setEditingModule(null);
      form.resetFields();
      fetchModules();
    } catch {
      message.error("Không thể lưu chương!");
    }
  };

  const handleDelete = async (id) => {
    await axios.delete(`/api/modules/${id}`);
    message.success("Đã xóa chương!");
    fetchModules();
  };

  const columns = [
    { title: "Tên chương", dataIndex: "name", key: "name" },
    { title: "Thứ tự", dataIndex: "number", key: "number" },
    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              setEditingModule(record);
              form.setFieldsValue(record);
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Xóa chương này?"
            onConfirm={() => handleDelete(record.id)}
          >
            <Button danger type="link">
              Xóa
            </Button>
          </Popconfirm>
          <Button
            type="link"
            onClick={() => {
              setSelectedModuleId(record.id);
              setIsLessonModalOpen(true);
            }}
          >
            Bài học
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <Modal
      title=" Quản lý chương"
      open={open}
      onCancel={onClose}
      footer={null}
      width={800}
    >
      <div style={{ marginBottom: 12 }}>
        <Button type="primary" onClick={() => setIsModalOpen(true)}>
          + Thêm chương
        </Button>
      </div>

      <Table
        dataSource={modules}
        columns={columns}
        loading={loading}
        rowKey="id"
        pagination={false}
      />

      <Modal
        title={editingModule ? "Sửa chương" : "Thêm chương"}
        open={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        onOk={handleSubmit}
      >
        <Form form={form} layout="vertical">
          <Form.Item
            name="name"
            label="Tên chương"
            rules={[{ required: true, message: "Vui lòng nhập tên chương" }]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            name="number"
            label="Thứ tự"
            rules={[
              { required: true, message: "Vui lòng nhập thứ tự chương" },
              {
                pattern: /^[0-9]+$/,
                message: "Thứ tự chỉ được chứa số nguyên dương",
              },
            ]}
          >
            <Input type="number" />
          </Form.Item>
        </Form>
      </Modal>

      <Modal
        title="Quản lý bài học"
        open={isLessonModalOpen}
        onCancel={() => setIsLessonModalOpen(false)}
        footer={null}
        width={800}
      >
        <LessonManager moduleId={selectedModuleId} courseId={courseId} />
      </Modal>
    </Modal>
  );
}
