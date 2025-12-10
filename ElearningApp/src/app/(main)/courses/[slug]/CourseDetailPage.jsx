"use client";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import axios from "@/utils/axios";
import { Collapse, message } from "antd";
import { PlayCircleOutlined, CheckOutlined } from "@ant-design/icons";
import { useRouter } from "next/navigation";

export default function CourseDetailPage() {
  const { slug } = useParams();
  const [course, setCourse] = useState(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  const fetchCourseDetail = async () => {
    try {
      const res = await axios.get(`/api/get-courses-by-slug/${slug}`);
      setCourse(res.data.data);
    } catch (error) {
      console.error(error);
      message.error("Không thể tải chi tiết khóa học!");
    } finally {
      setLoading(false);
    }
  };

  const formatDuration = (seconds) => {
    if (!seconds) return "0:00";
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m}:${s.toString().padStart(2, "0")}`;
  };

  const calculateTotalDuration = (modules) => {
    if (!modules) return "0:00";
    let totalSeconds = 0;
    modules.forEach((m) =>
      m.lessons?.forEach((l) => (totalSeconds += parseInt(l.duration || 0)))
    );
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, "0")}`;
  };

  const getYouTubeId = (url) => {
    const regExp =
      /^.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|watch\?.+&v=)([^#&?]*).*/;
    const match = url.match(regExp);
    return match && match[1].length === 11 ? match[1] : null;
  };

  const handleRegisterCourse = () => {
    if (!course) return;
    const hashId = btoa(course.id);
    router.push(`/courses/${slug}?id=${hashId}`);
  };

  useEffect(() => {
    if (slug) fetchCourseDetail();
  }, [slug]);

  if (loading)
    return (
      <div className="d-flex justify-content-center py-5">
        <div className="spinner-border text-primary" role="status">
          <span className="visually-hidden">Loading...</span>
        </div>
      </div>
    );
  if (!course)
    return <p className="text-center py-5">Không tìm thấy khóa học</p>;

  const firstLessonUrl = course.modules?.[0]?.lessons?.[0]?.video_url || null;

  const collapseItems = course.modules?.map((module, i) => ({
    key: module.id,
    label: `${i + 1}. ${module.name}`,
    children: (
      <ul className="list-unstyled mb-0">
        {module.lessons?.map((lesson) => (
          <li
            key={lesson.id}
            className="d-flex align-items-center justify-content-between py-1 border-bottom"
          >
            <div>
              <PlayCircleOutlined className="text-primary me-2" />
              {lesson.name}
            </div>
            <small className="text-muted">
              {formatDuration(lesson.duration)}
            </small>
          </li>
        ))}
      </ul>
    ),
    extra: `${module.lessons?.length || 0} bài học`,
  }));

  const handlePurchase = async () => {
    try {
      const res = await axios.post("/api/purchase-course", {
        course_id: course.id,
      });
      const { vnp_Url } = res.data;
      if (vnp_Url) {
        
        sessionStorage.setItem(
          "pendingPurchase",
          JSON.stringify({
            slug,
            hashId: btoa(course.id),
            orderCode: res.data.orderCode,
          })
        );
        window.location.href = vnp_Url;
      }
    } catch (err) {
      console.error(err);
      message.error("Không thể tạo đơn");
    }
  };

  return (
    <div className="container py-5">
      <div className="row g-4">
        <div className="col-md-8">
          <div className="ratio ratio-16x9 mb-3">
            {firstLessonUrl ? (
              firstLessonUrl.includes("youtube.com") ||
              firstLessonUrl.includes("youtu.be") ? (
                <iframe
                  src={`https://www.youtube.com/embed/${getYouTubeId(
                    firstLessonUrl
                  )}`}
                  title={course.modules[0].lessons[0].name}
                  allowFullScreen
                />
              ) : (
                <video
                  src={firstLessonUrl}
                  controls
                  className="rounded w-100"
                  style={{ objectFit: "cover" }}
                >
                  Trình duyệt không hỗ trợ video.
                </video>
              )
            ) : (
              <div className="bg-light d-flex align-items-center justify-content-center h-100">
                <PlayCircleOutlined
                  style={{ fontSize: "3rem", color: "#0d6efd" }}
                />
              </div>
            )}
          </div>

          <h1 className="h3 fw-bold">{course.name}</h1>
          <p className="text-secondary">{course.description}</p>

          <div className="d-flex flex-wrap gap-3 text-secondary mb-3">
            <span className="me-2">
              <i className="bi bi-laptop"></i>{" "}
              <span className="fw-bold">
                {course.category?.name || "Chưa phân loại"}{" "}
              </span>
            </span>
            <span className="me-2">
              <i className="bi bi-clock"></i> Tổng thời lượng:{" "}
              <span className="fw-bold">
                {" "}
                {calculateTotalDuration(course.modules)}
              </span>
            </span>
            <span>
              <i className="bi bi-people"></i>{" "}
              <span className="fw-bold"> Trình độ cơ bản </span>
            </span>
          </div>

          <button
            className="btn btn-primary btn-lg w-100 mb-3"
            onClick={handlePurchase}
          >
            {course.price
              ? `Mua khoá học chỉ với giá ${new Intl.NumberFormat("vi-VN", {
                  style: "currency",
                  currency: "VND",
                }).format(course.price)}`
              : " Đăng ký học"}
          </button>

          <ul className="list-unstyled text-secondary">
            <li>
              <CheckOutlined className="text-success me-2" /> Trình độ: Cơ bản
            </li>
            <li>
              <CheckOutlined className="text-success me-2" /> Tổng{" "}
              {course.modules?.length || 0} chương
            </li>
            <li>
              <CheckOutlined className="text-success me-2" /> Học mọi lúc, mọi
              nơi
            </li>
          </ul>
        </div>

        <div className="col-md-4">
          <h2 className="h5 mb-3">Nội dung khóa học</h2>
          <Collapse accordion items={collapseItems} />
        </div>
      </div>
    </div>
  );
}
