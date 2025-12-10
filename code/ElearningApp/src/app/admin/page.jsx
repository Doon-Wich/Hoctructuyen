"use client";

import { Card, Col, Row, Statistic, Typography, Button } from "antd";
import {
  ArrowUpOutlined,
  ArrowDownOutlined,
  BookOutlined,
  UserOutlined,
  DollarOutlined,
} from "@ant-design/icons";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

const { Title, Text } = Typography;

const data = [
  { name: "T1", sales: 400 },
  { name: "T2", sales: 600 },
  { name: "T3", sales: 800 },
  { name: "T4", sales: 700 },
  { name: "T5", sales: 1000 },
  { name: "T6", sales: 1200 },
  { name: "T7", sales: 900 },
];

export default function AdminPage() {
  return (
    <div style={{ padding: 24 }}>
      <Title level={2}>📊 Trang quản trị</Title>
      <Text type="secondary">
        Chào mừng bạn trở lại! Dưới đây là thống kê nhanh hôm nay.
      </Text>

      <Row gutter={[16, 16]} style={{ marginTop: 20 }}>
        <Col xs={24} sm={12} md={6}>
          <Card
            variant="borderless"
            style={{
              borderRadius: 12,
              boxShadow: "0 2px 10px rgba(0,0,0,0.05)",
            }}
          >
            <Statistic
              title="Tổng khóa học"
              value={34}
              prefix={<BookOutlined style={{ color: "#1677ff" }} />}
              valueStyle={{ color: "#1677ff" }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} md={6}>
          <Card
            variant="borderless"
            style={{
              borderRadius: 12,
              boxShadow: "0 2px 10px rgba(0,0,0,0.05)",
            }}
          >
            <Statistic
              title="Người dùng mới"
              value={12}
              prefix={<UserOutlined style={{ color: "#52c41a" }} />}
              valueStyle={{ color: "#52c41a" }}
              suffix={<ArrowUpOutlined />}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} md={6}>
          <Card
            variant="borderless"
            style={{
              borderRadius: 12,
              boxShadow: "0 2px 10px rgba(0,0,0,0.05)",
            }}
          >
            <Statistic
              title="Doanh thu"
              value={18500000}
              precision={0}
              prefix={<DollarOutlined style={{ color: "#faad14" }} />}
              valueStyle={{ color: "#faad14" }}
              suffix="đ"
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} md={6}>
          <Card
            variant="borderless"
            style={{
              borderRadius: 12,
              boxShadow: "0 2px 10px rgba(0,0,0,0.05)",
            }}
          >
            <Statistic
              title="Tăng trưởng"
              value={8.5}
              precision={1}
              valueStyle={{ color: "#cf1322" }}
              prefix={<ArrowDownOutlined />}
              suffix="%"
            />
          </Card>
        </Col>
      </Row>

      <Card
        title="📈 Doanh thu theo tháng"
        variant="borderless"
        style={{
          marginTop: 24,
          borderRadius: 12,
          boxShadow: "0 2px 10px rgba(0,0,0,0.05)",
        }}
      >
        <ResponsiveContainer width="100%" height={300}>
          <LineChart
            data={data}
            margin={{ top: 5, right: 20, left: 10, bottom: 5 }}
          >
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="name" />
            <YAxis />
            <Tooltip />
            <Line
              type="monotone"
              dataKey="sales"
              stroke="#1677ff"
              strokeWidth={2}
            />
          </LineChart>
        </ResponsiveContainer>
      </Card>

      <div style={{ marginTop: 30, textAlign: "center" }}>
        <Button type="primary" size="large" shape="round">
          Tạo khóa học mới
        </Button>
      </div>
    </div>
  );
}
