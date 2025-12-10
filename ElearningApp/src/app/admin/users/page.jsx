"use client";
import { useEffect, useState } from "react";
import {
  Table,
  Button,
  Modal,
  Form,
  Input,
  Switch,
  Space,
  Popconfirm,
  message,
  Select,
} from "antd";
import axios from "@/utils/axios";

export default function UserManagerPage() {
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState(null);
  const [form] = Form.useForm();

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/users");
      const data = Array.isArray(res.data) ? res.data : res.data.data;
      setUsers(data || []);
    } catch (error) {
      console.error(error);
      message.error("Không thể tải danh sách người dùng");
    } finally {
      setLoading(false);
    }
  };

  const fetchRoles = async () => {
    try {
      const res = await axios.get("/api/roles");
      const data = Array.isArray(res.data) ? res.data : res.data.data;
      setRoles(data || []);
    } catch (error) {
      console.error(error);
      message.error("Không thể tải danh sách vai trò");
    }
  };

  useEffect(() => {
    fetchUsers();
    fetchRoles();
  }, []);

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      if (editingUser) {
        await axios.put(`/api/users/${editingUser.id}`, values);
        message.success("Cập nhật user thành công!");
      } else {
        await axios.post("/api/users", values);
        message.success("Thêm user thành công!");
      }
      setIsModalOpen(false);
      setEditingUser(null);
      form.resetFields();
      fetchUsers();
    } catch (error) {
      console.error(error);
      message.error("Lưu thất bại, kiểm tra dữ liệu!");
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/api/users/${id}`);
      message.success("Đã xóa người dùng!");
      fetchUsers();
    } catch (error) {
      console.error(error);
      message.error("Không thể xóa người dùng!");
    }
  };

  const columns = [
    { title: "ID", dataIndex: "id", key: "id" },
    { title: "Họ và tên", dataIndex: "full_name", key: "full_name" },
    { title: "Email", dataIndex: "email", key: "email" },
    {
      title: "Vai trò",
      dataIndex: ["role", "name"],
      key: "role",
      render: (_, record) => record?.role?.name || "—",
    },
    {
      title: "Trạng thái",
      dataIndex: "status",
      key: "status",
      render: (status) => (status ? "Active" : "Inactive"),
    },
    {
      title: "Hành động",
      key: "actions",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            onClick={() => {
              setEditingUser(record);
              form.setFieldsValue({
                ...record,
                role_id: record?.role?.id,
              });
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>
          <Popconfirm
            title="Xóa user này?"
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
      <h1 style={{ fontSize: 24, marginBottom: 16 }}> Quản lý tài khoản</h1>
      <Button
        type="primary"
        style={{ marginBottom: 16 }}
        onClick={() => {
          form.resetFields();
          setEditingUser(null);
          setIsModalOpen(true);
        }}
      >
        + Thêm tài khoản
      </Button>

      <Table
        dataSource={users || []}
        columns={columns}
        rowKey="id"
        loading={loading}
        pagination={{ pageSize: 5 }}
      />

      <Modal
        title={editingUser ? "Sửa tài khoản" : "Thêm tài khoản"}
        open={isModalOpen}
        onCancel={() => {
          setIsModalOpen(false);
          setEditingUser(null);
          form.resetFields(); 
        }}
        onOk={() => form.submit()}
        okText="Lưu"
        cancelText="Hủy"
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleSubmit}
        >
          <Form.Item
            name="full_name"
            label="Họ và tên"
            rules={[
              { required: true, message: "Vui lòng nhập họ và tên" },
              { max: 100, message: "Họ và tên không được vượt quá 100 ký tự" },
            ]}
          >
            <Input placeholder="Nhập họ và tên" />
          </Form.Item>

          <Form.Item
            name="email"
            label="Email"
            rules={[
              { required: true, message: "Vui lòng nhập email" },
              { type: "email", message: "Email không hợp lệ" },
            ]}
          >
            <Input placeholder="Nhập email người dùng" />
          </Form.Item>

          {!editingUser && (
            <Form.Item
              name="password"
              label="Mật khẩu"
              rules={[
                { required: true, message: "Vui lòng nhập mật khẩu" },
                {
                  min: 6,
                  message: "Mật khẩu phải có ít nhất 6 ký tự",
                },
              ]}
            >
              <Input.Password placeholder="Nhập mật khẩu" />
            </Form.Item>
          )}

          <Form.Item
            name="role_id"
            label="Vai trò"
            rules={[{ required: true, message: "Vui lòng chọn vai trò" }]}
          >
            <Select
              placeholder="Chọn vai trò"
              options={roles.map((r) => ({
                label: r.name,
                value: r.id,
              }))}
            />
          </Form.Item>

          <Form.Item name="status" label="Kích hoạt" valuePropName="checked">
            <Switch />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
