"use client";

import React, { useEffect, useState } from "react";
import { Button, Checkbox, Form, Input } from "antd";
import "@ant-design/v5-patch-for-react-19";
import axiosClient from "@/utils/axios";
import { useRouter } from "next/navigation";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

export default function Login() {
  const [timeDelay, setTimeDelay] = useState(0);
  const router = useRouter();

  useEffect(() => {
    if (timeDelay <= 0) return;
    const timer = setInterval(() => {
      setTimeDelay((prev) => prev - 1);
    }, 1000);
    return () => clearInterval(timer);
  }, [timeDelay]);

  const handleLogin = async (values) => {
    try {
      const res = await axiosClient.post("/api/login", {
        email: values.email,
        password: values.password,
        device_name: "Web",
      });

      if (res.data.status === "success") {
        localStorage.setItem("token", res.data.token);
        localStorage.setItem("user", JSON.stringify(res.data.user));

        toast.success("Đăng nhập thành công", {
          position: "top-right",
          autoClose: 1500,
        });

        setTimeout(() => router.push("/"), 1000);
      }
    } catch (err) {
      const msg =
        err.response?.data?.message || "Đăng nhập thất bại. Vui lòng thử lại!";
      toast.error(msg, {
        position: "top-right",
        autoClose: 2500,
      });
    }
  };

  const onFinish = async (values) => {
    await handleLogin(values);
  };

  const onFinishFailed = (errorInfo) => {
    console.log("Failed:", errorInfo);
  };

  return (
    <>
      <Form
        name="basic"
        labelCol={{ span: 8 }}
        wrapperCol={{ span: 16 }}
        style={{ maxWidth: 600 }}
        onFinish={onFinish}
        onFinishFailed={onFinishFailed}
        autoComplete="off"
      >
        <Form.Item
          label="Email"
          name="email"
          rules={[
            { required: true, message: "Vui lòng nhập email!" },
            { type: "email", message: "Email không hợp lệ!" },
          ]}
        >
          <Input />
        </Form.Item>

        <Form.Item
          label="Mật khẩu"
          name="password"
          rules={[{ required: true, message: "Vui lòng nhập mật khẩu!" }]}
        >
          <Input.Password />
        </Form.Item>

        <Form.Item name="remember" valuePropName="checked" label={null}>
          <Checkbox>Nhớ mật khẩu</Checkbox>
        </Form.Item>

        <Form.Item label={null}>
          <Button type="primary" htmlType="submit" className="w-full">
            Đăng nhập
          </Button>
        </Form.Item>
      </Form>

      <div className="text-center mt-4">
        <span className="text-gray-600">Chưa có tài khoản? </span>
        <Button
          type="link"
          onClick={() => router.push("/auth/register")}
          className="text-blue-600 hover:text-blue-800 font-medium"
        >
          Đăng ký ngay
        </Button>
      </div>
    </>
  );
}
