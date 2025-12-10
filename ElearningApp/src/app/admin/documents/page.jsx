"use client";

import { useEffect, useState } from "react";
import {
  Form,
  Input,
  Select,
  Button,
  Upload,
  message,
  Card,
  Space,
} from "antd";
import { UploadOutlined } from "@ant-design/icons";
import axios from "@/utils/axios";

export default function UploadDocumentPage() {
  const [courses, setCourses] = useState([]);
  const [modules, setModules] = useState([]);
  const [lessons, setLessons] = useState([]);
  const [loading, setLoading] = useState(false);

  const [form] = Form.useForm();

  // Load Courses
  useEffect(() => {
    axios
      .get("/api/courses")
      .then((res) => {
        let data = [];
        if (Array.isArray(res.data)) data = res.data;
        else if (res.data && Array.isArray(res.data.data)) data = res.data.data;
      })
      .catch(() => message.error("Không tải được danh sách khóa học"));
  }, []);

  const loadModules = (courseId) => {
    form.setFieldsValue({ module_id: null, lesson_id: null });
    setModules([]);
    setLessons([]);

    axios.get(`/api/module?course_id=${courseId}`).then((res) => {
      const data = Array.isArray(res?.data?.data)
        ? res.data.data
        : Array.isArray(res?.data)
        ? res.data
        : [];

      setModules(data);
    });
  };

  const loadLessons = (moduleId) => {
    form.setFieldsValue({ lesson_id: null });
    setLessons([]);

    axios.get(`/api/lessons?module_id=${moduleId}`).then((res) => {
      const data = Array.isArray(res?.data?.data)
        ? res.data.data
        : Array.isArray(res?.data)
        ? res.data
        : [];
      setLessons(data);
    });
  };

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();

      const formData = new FormData();
      formData.append("course_id", values.course_id);
      formData.append("module_id", values.module_id || "");
      formData.append("lesson_id", values.lesson_id || "");
      formData.append("title", values.title);
      formData.append("file", values.file.file.originFileObj);

      setLoading(true);

      await axios.post("/documents", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      message.success("Upload thành công! Tài liệu đang được xử lý...");
      form.resetFields();
    } catch (e) {
      console.log(e);
      message.error("Upload thất bại!");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ padding: 32, maxWidth: 700, margin: "0 auto" }}>
      <Card title="📄 Upload tài liệu RAG" bordered>
        <Form layout="vertical" form={form} onFinish={handleSubmit}>
          <Form.Item
            name="course_id"
            label="Khoá học"
            rules={[{ required: true, message: "Chọn khoá học!" }]}
          >
            <Select
              placeholder="Chọn khoá học"
              options={courses.map((c) => ({
                label: c.name,
                value: c.id,
              }))}
              onChange={loadModules}
            />
          </Form.Item>

          {/* MODULE */}
          <Form.Item name="module_id" label="Chương (không bắt buộc)">
            <Select
              placeholder="Chọn chương"
              allowClear
              options={modules.map((m) => ({
                label: m.name,
                value: m.id,
              }))}
              onChange={loadLessons}
            />
          </Form.Item>

          {/* LESSON */}
          <Form.Item name="lesson_id" label="Bài học (không bắt buộc)">
            <Select
              placeholder="Chọn bài học"
              allowClear
              options={lessons.map((l) => ({
                label: l.name,
                value: l.id,
              }))}
            />
          </Form.Item>

          {/* TITLE */}
          <Form.Item
            name="title"
            label="Tiêu đề tài liệu"
            rules={[{ required: true, message: "Nhập tiêu đề tài liệu!" }]}
          >
            <Input placeholder="VD: Slide chương 1" />
          </Form.Item>

          {/* FILE */}
          <Form.Item
            name="file"
            label="File tài liệu"
            rules={[{ required: true, message: "Chọn file!" }]}
          >
            <Upload beforeUpload={() => false}>
              <Button icon={<UploadOutlined />}>Chọn file</Button>
            </Upload>
          </Form.Item>

          <Form.Item>
            <Space>
              <Button type="primary" htmlType="submit" loading={loading}>
                Upload
              </Button>
              <Button onClick={() => form.resetFields()}>Reset</Button>
            </Space>
          </Form.Item>
        </Form>
      </Card>
    </div>
  );
}
