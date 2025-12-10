"use client";

import React, { useState } from "react";
import { Button, Checkbox, Form, Input, Select, message } from "antd";
import "@ant-design/v5-patch-for-react-19";
import axios from "@/utils/axios";
import { useRouter } from "next/navigation";
import { toast } from "react-toastify";

export default function Register() {
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleRegister = async (values) => {
    setLoading(true);
    try {
      const response = await axios.post("/api/register", {
        full_name: values.full_name,
        email: values.email,
        password: values.password,
        password_confirmation: values.password_confirmation,
        role_id: values.role_id || 2,
        device_name: "Web",
      });

      if (response.data.status === "success") {
        localStorage.setItem("login_token", response.data.token);
        toast.success("Đăng ký thành công!", { position: "top-right" });
        router.push("/");
      }
    } catch (error) {
      console.error(error);

      if (error.response?.status === 422 && error.response?.data?.errors) {
        const errors = error.response.data.errors;
        Object.values(errors).forEach((messages) => {
          messages.forEach((msg) =>
            toast.error(msg, { position: "top-right" })
          );
        });
      } else if (error.response?.data?.message) {
        toast.error(error.response.data.message, { position: "top-right" });
      } else {
        toast.error("Đăng ký thất bại, vui lòng thử lại!", {
          position: "top-right",
        });
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-50">
      <Form
        name="register"
        labelCol={{ span: 8 }}
        wrapperCol={{ span: 16 }}
        style={{ maxWidth: 600 }}
        onFinish={handleRegister}
        autoComplete="off"
      >
        <h2 className="text-2xl font-semibold text-center mb-6">
          Đăng ký tài khoản
        </h2>

        <Form.Item
          label="Họ và tên"
          name="full_name"
          rules={[{ required: true, message: "Vui lòng nhập họ và tên!" }]}
        >
          <Input placeholder="Nguyễn Văn A" />
        </Form.Item>

        <Form.Item
          label="Email"
          name="email"
          rules={[
            { required: true, message: "Vui lòng nhập email!" },
            { type: "email", message: "Email không hợp lệ!" },
          ]}
        >
          <Input placeholder="email@example.com" />
        </Form.Item>

        <Form.Item
          label="Mật khẩu"
          name="password"
          rules={[{ required: true, message: "Vui lòng nhập mật khẩu!" }]}
        >
          <Input.Password placeholder="••••••••" />
        </Form.Item>

        <Form.Item
          label="Xác nhận mật khẩu"
          name="password_confirmation"
          dependencies={["password"]}
          rules={[
            { required: true, message: "Vui lòng xác nhận mật khẩu!" },
            ({ getFieldValue }) => ({
              validator(_, value) {
                if (!value || getFieldValue("password") === value) {
                  return Promise.resolve();
                }
                return Promise.reject(
                  new Error("Mật khẩu xác nhận không khớp!")
                );
              },
            }),
          ]}
        >
          <Input.Password placeholder="Nhập lại mật khẩu" />
        </Form.Item>

        <Form.Item label="Vai trò" name="role_id">
          <Select placeholder="Chọn vai trò" allowClear>
            <Select.Option value={1}>Giáo viên</Select.Option>
            <Select.Option value={2}>Học sinh</Select.Option>
            <Select.Option value={3}>Quản trị viên</Select.Option>
          </Select>
        </Form.Item>

        <Form.Item name="remember" valuePropName="checked" label={null}>
          <Checkbox>Tôi đồng ý với điều khoản</Checkbox>
        </Form.Item>

        <Form.Item label={null}>
          <Button
            type="primary"
            htmlType="submit"
            loading={loading}
            className="w-full"
          >
            Đăng ký
          </Button>
        </Form.Item>

        <div className="text-center text-sm">
          Đã có tài khoản?{" "}
          <a href="/auth/login" className="text-blue-600 hover:underline">
            Đăng nhập ngay
          </a>
        </div>
      </Form>
    </div>
  );
}
