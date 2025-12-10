"use client";

import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  DatePicker,
  Space,
  Popconfirm,
  message,
  Select,
} from "antd";
import axios from "@/utils/axios";
import dayjs from "dayjs";
import FileUpload from "@/components/FileUpload";

export default function AssignmentManagerPage() {
  const [assignments, setAssignments] = useState([]);
  const [lessons, setLessons] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingAssignment, setEditingAssignment] = useState(null);
  const [form] = Form.useForm();

  const fetchAssignments = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/assignments");
      const data = res.data.data || [];
      setAssignments(data);
    } catch (error) {
      console.error(error);
      message.error("Không thể tải danh sách bài tập");
    } finally {
      setLoading(false);
    }
  };

  const fetchLessons = async () => {
    try {
      const res = await axios.get("/api/lessons");
      const data = res.data.data || [];
      setLessons(data);
    } catch (error) {
      console.error(error);
      message.error("Không thể tải danh sách bài học");
    }
  };

  useEffect(() => {
    fetchAssignments();
    fetchLessons();
  }, []);

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      const payload = {
        ...values,
        deadline: values.deadline ? values.deadline.format("YYYY-MM-DD") : null,
      };

      if (editingAssignment) {
        await axios.put(`/api/assignments/${editingAssignment.id}`, payload);
        message.success("Cập nhật bài tập thành công!");
      } else {
        await axios.post("/api/assignments", payload);
        message.success("Thêm bài tập thành công!");
      }

      setIsModalOpen(false);
      setEditingAssignment(null);
      form.resetFields();
      fetchAssignments();
    } catch (error) {
      console.error(error);
      message.error("Lưu thất bại, kiểm tra dữ liệu!");
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/api/assignments/${id}`);
      message.success("Đã xóa bài tập!");
      fetchAssignments();
    } catch (error) {
      console.error(error);
      message.error("Không thể xóa bài tập!");
    }
  };

  const columns = [
    { title: "ID", dataIndex: "id", key: "id" },
    { title: "Tên bài tập", dataIndex: "title", key: "title" },
    { title: "Bài học", dataIndex: ["lesson", "name"], key: "lesson" },
    { title: "Mô tả", dataIndex: "description", key: "description" },
    {
      title: "Deadline",
      dataIndex: "deadline",
      key: "deadline",
      render: (text) => (text ? dayjs(text).format("DD/MM/YYYY") : "—"),
    },
    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              setEditingAssignment(record);
              form.setFieldsValue({
                ...record,
                deadline: record.deadline ? dayjs(record.deadline) : null,
              });
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Xóa bài tập này?"
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
      <h1 style={{ fontSize: 24, marginBottom: 16 }}>Quản lý bài tập</h1>
      <Button
        type="primary"
        style={{ marginBottom: 16 }}
        onClick={() => {
          form.resetFields();
          setEditingAssignment(null);
          setIsModalOpen(true);
        }}
      >
        + Thêm bài tập
      </Button>

      <Table
        dataSource={assignments || []}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{ pageSize: 5 }}
      />

      <Modal
        title={editingAssignment ? "Sửa bài tập" : "Thêm bài tập"}
        open={isModalOpen}
        onCancel={() => {
          setIsModalOpen(false);
          setEditingAssignment(null);
          form.resetFields();
        }}
        onOk={() => form.submit()}
        okText="Lưu"
        cancelText="Hủy"
      >
        <Form form={form} layout="vertical" onFinish={handleSubmit}>
          <Form.Item
            name="title"
            label="Tên bài tập"
            rules={[{ required: true, message: "Vui lòng nhập tên bài tập" }]}
          >
            <Input placeholder="Nhập tên bài tập" />
          </Form.Item>

          <Form.Item
            name="lesson_id"
            label="Thuộc bài học"
            rules={[{ required: true, message: "Vui lòng chọn bài học" }]}
          >
            <Select
              placeholder="Chọn bài học"
              options={lessons.map((l) => ({ label: l.name, value: l.id }))}
            />
          </Form.Item>

          <Form.Item name="description" label="Mô tả">
            <Input.TextArea placeholder="Mô tả bài tập" />
          </Form.Item>

          <Form.Item
            name="attachment"
            label="File đính kèm"
            valuePropName="file"
          >
            <FileUpload
              onChange={(url) => form.setFieldValue("attachment", url)}
              initialValue={editingAssignment?.attachment}
            />
          </Form.Item>

          <Form.Item name="deadline" label="Hạn nộp">
            <DatePicker format="DD/MM/YYYY" style={{ width: "100%" }} />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
