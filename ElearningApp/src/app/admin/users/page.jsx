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
  Tag,
} from "antd";
import { PlusOutlined, EditOutlined, DeleteOutlined } from "@ant-design/icons";
import axios from "@/utils/axios";

export default function UserManagerPage() {
  const [users, setUsers] = useState([]);
  const [roles, setRoles] = useState([]);
  const [loading, setLoading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState(null);

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const res = await axios.get("/api/users");
      setUsers(Array.isArray(res.data) ? res.data : res.data.data || []);
    } catch {
      message.error("Không thể tải danh sách người dùng");
    } finally {
      setLoading(false);
    }
  };

  const fetchRoles = async () => {
    try {
      const res = await axios.get("/api/roles");
      setRoles(Array.isArray(res.data) ? res.data : res.data.data || []);
    } catch {
      message.error("Không thể tải danh sách vai trò");
    }
  };

  useEffect(() => {
    fetchUsers();
    fetchRoles();
  }, []);

  const handleSubmit = async (values) => {
    try {
      if (editingUser) {
        await axios.put(`/api/users/${editingUser.id}`, values);
        message.success("Cập nhật user thành công!");
      } else {
        await axios.post("/api/users", values);
        message.success("Thêm user thành công!");
      }
      setIsModalOpen(false);
      setEditingUser(null);
      fetchUsers();
    } catch {
      message.error("Lưu thất bại, kiểm tra dữ liệu!");
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`/api/users/${id}`);
      message.success("Đã xóa người dùng!");
      fetchUsers();
    } catch {
      message.error("Không thể xóa người dùng!");
    }
  };

  const columns = [
    { title: "ID", dataIndex: "id", width: 70 },
    { title: "Họ và tên", dataIndex: "full_name" },
    { title: "Email", dataIndex: "email" },
    {
      title: "Vai trò",
      render: (_, r) => <Tag color="blue">{r?.role?.name || "—"}</Tag>,
    },
    {
      title: "Trạng thái",
      render: (_, r) =>
        r.status ? (
          <Tag color="green">Active</Tag>
        ) : (
          <Tag color="red">Inactive</Tag>
        ),
    },
    {
      title: "Hành động",
      align: "center",
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            icon={<EditOutlined />}
            onClick={() => {
              setEditingUser(record);
              setIsModalOpen(true);
            }}
          >
            Sửa
          </Button>

          <Popconfirm
            title="Xóa user này?"
            okText="Xóa"
            cancelText="Hủy"
            onConfirm={() => handleDelete(record.id)}
          >
            <Button danger type="link" icon={<DeleteOutlined />}>
              Xóa
            </Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      {/* Header */}
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          marginBottom: 16,
        }}
      >
        <h2 style={{ margin: 0 }}>Quản lý tài khoản</h2>
        <Button
          type="primary"
          icon={<PlusOutlined />}
          onClick={() => {
            setEditingUser(null);
            setIsModalOpen(true);
          }}
        >
          Thêm tài khoản
        </Button>
      </div>

      <Table
        rowKey="id"
        loading={loading}
        dataSource={users}
        columns={columns}
        pagination={{ pageSize: 5 }}
      />

      <Modal
        open={isModalOpen}
        title={editingUser ? "Sửa tài khoản" : "Thêm tài khoản"}
        onCancel={() => {
          setIsModalOpen(false);
          setEditingUser(null);
        }}
        okText="Lưu"
        cancelText="Hủy"
        width={520}
        destroyOnHidden
        footer={null}
      >
        <Form
          layout="vertical"
          onFinish={handleSubmit}
          initialValues={
            editingUser
              ? { ...editingUser, role_id: editingUser?.role?.id }
              : { status: true }
          }
        >
          <Form.Item
            name="full_name"
            label="Họ và tên"
            rules={[{ required: true, message: "Vui lòng nhập họ và tên" }]}
          >
            <Input placeholder="Nhập họ và tên người dùng" />
          </Form.Item>

          <Form.Item
            name="email"
            label="Email"
            rules={[
              { required: true, message: "Vui lòng nhập email" },
              { type: "email", message: "Email không hợp lệ" },
            ]}
          >
            <Input placeholder="example@email.com" />
          </Form.Item>

          {!editingUser && (
            <Form.Item
              name="password"
              label="Mật khẩu"
              rules={[
                { required: true, message: "Vui lòng nhập mật khẩu" },
                { min: 6, message: "Mật khẩu tối thiểu 6 ký tự" },
              ]}
            >
              <Input.Password placeholder="Nhập mật khẩu đăng nhập" />
            </Form.Item>
          )}

          <Form.Item
            name="role_id"
            label="Vai trò"
            rules={[{ required: true, message: "Vui lòng chọn vai trò" }]}
          >
            <Select
              placeholder="Chọn vai trò cho tài khoản"
              options={roles.map((r) => ({
                label: r.name,
                value: r.id,
              }))}
            />
          </Form.Item>

          <Form.Item
            name="status"
            label="Kích hoạt"
            valuePropName="checked"
            extra="Tắt nếu muốn vô hiệu hóa tài khoản"
          >
            <Switch />
          </Form.Item>

          <Form.Item style={{ textAlign: "right" }}>
            <Space>
              <Button onClick={() => setIsModalOpen(false)}>Hủy</Button>
              <Button type="primary" htmlType="submit">
                Lưu thay đổi
              </Button>
            </Space>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
