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
  Upload,
} from "antd";
import TextArea from "antd/es/input/TextArea";
import { UploadOutlined } from "@ant-design/icons";
import axios from "@/utils/axios";

export default function LessonManager({ moduleId, courseId }) {
  const [lessons, setLessons] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingLesson, setEditingLesson] = useState(null);
  const [fileList, setFileList] = useState([]);
  const [uploading, setUploading] = useState(false);
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
      let lessonId = editingLesson?.id;

      // Thêm hoặc sửa lesson
      if (editingLesson) {
        await axios.put(`/api/lessons/${lessonId}`, {
          ...values,
          module_id: moduleId,
        });
      } else {
        const res = await axios.post(`/api/lessons`, {
          ...values,
          module_id: moduleId,
        });
        lessonId = res.data.id;
      }

      // Upload file
      if (fileList.length > 0) {
        const formData = new FormData();
        formData.append("course_id", courseId);
        formData.append("file", fileList[0].originFileObj);
        formData.append("module_id", moduleId);
        formData.append("lesson_id", lessonId);
        formData.append("title", values.title);

        setUploading(true);
        await axios.post("/api/documents", formData, {
          headers: { "Content-Type": "multipart/form-data" },
        });
        setUploading(false);
        message.success("Upload tài liệu thành công!");
      }

      message.success("Lưu bài học thành công!");
      setIsModalOpen(false);
      fetchLessons();
      form.resetFields();
      setFileList([]);
    } catch (e) {
      console.error(e);
      message.error("Lưu bài học thất bại!");
      setUploading(false);
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
          setFileList([]);
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
        okButtonProps={{ loading: uploading }}
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

          <Form.Item
            name="title"
            label="Tiêu đề tài liệu"
            rules={[{ required: true, message: "Nhập tiêu đề tài liệu!" }]}
          >
            <Input placeholder="VD: Slide chương 1" />
          </Form.Item>

          <Form.Item
            label="Tài liệu đính kèm"
            valuePropName="fileList"
            getValueFromEvent={(e) => (Array.isArray(e) ? e : e?.fileList)}
          >
            <Upload.Dragger
              beforeUpload={() => false} // ngăn auto upload
              maxCount={1}
              fileList={fileList}
              onChange={({ fileList }) => setFileList(fileList)}
              style={{
                borderStyle: "dashed",
                borderRadius: 8,
                padding: "24px 0",
                textAlign: "center",
              }}
            >
              <p className="ant-upload-drag-icon">
                <UploadOutlined style={{ fontSize: 24 }} />
              </p>
              <p className="ant-upload-text">
                Kéo thả file vào đây hoặc bấm để chọn
              </p>
            </Upload.Dragger>
          </Form.Item>
        </Form>
      </Modal>
    </>
  );
}
