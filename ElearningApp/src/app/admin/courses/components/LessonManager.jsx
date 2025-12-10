"use client";
import { useState, useEffect } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  InputNumber,
  Space,
  Popconfirm,
  message,
} from "antd";
import axios from "@/utils/axios";
import TextArea from "antd/es/input/TextArea";

export default function LessonManager({ moduleId }) {
  const [lessons, setLessons] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingLesson, setEditingLesson] = useState(null);
  const [form] = Form.useForm();

  const fetchLessons = async () => {
    if (!moduleId) return;
    setLoading(true);
    try {
      const res = await axios.get(`/api/lessons?module_id=${moduleId}`);

      const data = Array.isArray(res?.data?.data)
        ? res.data.data
        : Array.isArray(res?.data)
        ? res.data
        : [];

      if (data.length === 0) {
        console.warn("Không có bài học nào trong module:", moduleId);
      }

      setLessons(data);
    } catch (error) {
      console.error("Lỗi khi tải danh sách bài học:", error);
      message.error("Không thể tải danh sách bài học!");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (moduleId) fetchLessons();
  }, [moduleId]);

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      if (editingLesson)
        await axios.put(`/api/lessons/${editingLesson.id}`, {
          ...values,
          module_id: moduleId,
        });
      else await axios.post(`/api/lessons`, { ...values, module_id: moduleId });

      message.success("Lưu bài học thành công!");
      setIsModalOpen(false);
      fetchLessons();
      form.resetFields();
    } catch {
      message.error("Không thể lưu bài học!");
    }
  };

  const handleDelete = async (id) => {
    await axios.delete(`/api/lessons/${id}`);
    message.success("Đã xóa bài học!");
    fetchLessons();
  };

  const columns = [
    { title: "Tên bài học", dataIndex: "name", key: "name" },
    { title: "Video URL", dataIndex: "video_url", key: "video_url" },
    { title: "Thời lượng (giây)", dataIndex: "duration", key: "duration" },
    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              setEditingLesson(record);
              form.setFieldsValue(record);
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Xóa bài học?"
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
      <Table
        dataSource={lessons}
        columns={columns}
        loading={loading}
        rowKey="id"
        pagination={false}
      />
      <Button
        type="primary"
        onClick={() => {
          setEditingLesson(null);
          form.resetFields();
          setIsModalOpen(true);
        }}
      >
        + Thêm bài học
      </Button>

      <Modal
        title={editingLesson ? "Sửa bài học" : "Thêm bài học"}
        open={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        onOk={handleSubmit}
      >
        <Form form={form} layout="vertical">
          <Form.Item
            name="name"
            label="Tên bài học"
            rules={[{ required: true, message: "Vui lòng nhập tên bài học" }]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            name="lesson_details"
            label="Chi tiết bài học"
            rules={[
              { required: true, message: "Vui lòng nhập chi tiết bài học" },
            ]}
          >
            <TextArea />
          </Form.Item>

          <Form.Item
            name="video_url"
            label="Video URL"
            rules={[
              { required: true, message: "Vui lòng nhập đường dẫn video" },
              { type: "url", message: "Đường dẫn không hợp lệ" },
            ]}
          >
            <Input />
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
}
