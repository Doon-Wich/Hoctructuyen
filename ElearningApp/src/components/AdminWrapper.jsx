"use client";

import { useState } from "react";
import { Layout, Menu } from "antd";
import {
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  DashboardOutlined,
  BookOutlined,
  UserOutlined,
  SettingOutlined,
  UnorderedListOutlined,
  HighlightOutlined,
  FormOutlined,
  QuestionCircleOutlined,
  FileProtectOutlined,
  BookTwoTone
} from "@ant-design/icons";
import "@ant-design/v5-patch-for-react-19";
import Link from "next/link";
import AssignmentManagerPage from "@/app/admin/assignments/page";

const { Header, Sider, Content, Footer } = Layout;

export default function AdminWrapper({ children }) {
  const [collapsed, setCollapsed] = useState(false);

  const toggle = () => setCollapsed(!collapsed);

  return (
    <Layout style={{ minHeight: "100vh" }}>
      <Sider collapsible collapsed={collapsed} onCollapse={setCollapsed}>
        <div
          className="logo"
          style={{ color: "white", textAlign: "center", padding: 16 }}
        >
          🎓 EduAdmin
        </div>
        <Menu
          theme="dark"
          mode="inline"
          defaultSelectedKeys={["1"]}
          items={[
            {
              key: "1",
              icon: <DashboardOutlined />,
              label: <Link href="/admin">Trang chủ</Link>,
            },
            {
              key: "2",
              icon: <BookOutlined />,
              label: <Link href="/admin/courses">Khoá học</Link>,
            },
            {
              key: "3",
              icon: <UnorderedListOutlined />,
              label: <Link href="/admin/categories">Danh mục khoá học</Link>,
            },
            {
              key: "4",
              icon: <UserOutlined />,
              label: <Link href="/admin/users">Người dùng</Link>,
            },
            {
              key: "5",
              icon: <HighlightOutlined />,
              label: <Link href="/admin/assignments">Bài tập</Link>,
            },
            {
              key: "6",
              icon: <FormOutlined />,
              label: <Link href="/admin/submissions">Kết quả bài tập</Link>,
            },
            {
              key: "7",
              icon: <FileProtectOutlined />,
              label: <Link href="/admin/quiz">Bài kiểm tra</Link>,
            },
            // {
            //   key: "8",
            //   icon: <BookTwoTone />,
            //   label: <Link href="/admin/documents">Tài liệu</Link>,
            // },
            {
              key: "9",
              icon: <SettingOutlined />,
              label: <Link href="/admin/settings">Cài đặt</Link>,
            },
            
          ]}
        />
      </Sider>

      <Layout>
        <Header
          style={{
            padding: "0 16px",
            background: "#fff",
            display: "flex",
            alignItems: "center",
          }}
        >
          {collapsed ? (
            <MenuUnfoldOutlined
              onClick={toggle}
              style={{ fontSize: 18, cursor: "pointer" }}
            />
          ) : (
            <MenuFoldOutlined
              onClick={toggle}
              style={{ fontSize: 18, cursor: "pointer" }}
            />
          )}
          <div style={{ marginLeft: "auto" }}>Admin</div>
        </Header>
        <Content style={{ margin: 16 }}>
          <div style={{ padding: 24, background: "#fff", minHeight: 360 }}>
            {children}
          </div>
        </Content>
        <Footer style={{ textAlign: "center" }}>© 2025 EduAdmin</Footer>
      </Layout>
    </Layout>
  );
}
