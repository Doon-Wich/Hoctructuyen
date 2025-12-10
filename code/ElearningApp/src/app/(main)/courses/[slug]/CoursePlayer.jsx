"use client";

import { useEffect, useState } from "react";
import axios from "@/utils/axios";
import { message, Progress } from "antd";
import {
  PlayCircleOutlined,
  DownOutlined,
  RightOutlined,
  ArrowLeftOutlined,
  FileTextOutlined,
} from "@ant-design/icons";
import { useRouter } from "next/navigation";

export default function CoursePlayer({ slug, courseHash }) {
  const [course, setCourse] = useState(null);
  const [currentLesson, setCurrentLesson] = useState(null);
  const [loading, setLoading] = useState(true);
  const [openModules, setOpenModules] = useState({});
  const [tracking, setTracking] = useState(null);
  const [trackingLoaded, setTrackingLoaded] = useState(false);
  const router = useRouter();

  useEffect(() => {
    const fetchCourse = async () => {
      try {
        const res = await axios.get(`/api/get-courses-by-slug/${slug}`);
        const courseData = res.data.data;
        const decodedId = atob(courseHash);

        if (courseData.id != decodedId) {
          message.error("Khóa học không hợp lệ!");
          return;
        }

        setCourse(courseData);
        setCurrentLesson(courseData.modules?.[0]?.lessons?.[0]);

        if (courseData.modules?.length > 0) {
          setOpenModules({ [courseData.modules[0].id]: true });
        }
      } catch (err) {
        console.error(err);
        message.error("Không thể tải khóa học!");
      } finally {
        setLoading(false);
      }
    };
    fetchCourse();
  }, [slug, courseHash]);

  useEffect(() => {
    if (!currentLesson) return;

    const fetchTracking = async () => {
      try {
        const res = await axios.get(
          `/api/lesson-tracking/get/${currentLesson.id}`
        );
        setTracking(res.data.data || null);
      } catch (err) {
        console.error("Không thể tải tiến độ bài học:", err);
      }
    };
    fetchTracking();
  }, [currentLesson]);

  useEffect(() => {
    if (!course || trackingLoaded) return;
  setTrackingLoaded(true);

    const fetchAllTracking = async () => {
      try {
        const allLessons = course.modules.flatMap((m) => m.lessons);
        const updatedLessons = await Promise.all(
          allLessons.map(async (lesson) => {
            try {
              const res = await axios.get(
                `/api/lesson-tracking/get/${lesson.id}`
              );
              return {
                ...lesson,
                tracking: res.data.data || null,
              };
            } catch (err) {
              return { ...lesson, tracking: null };
            }
          })
        );

        // Cập nhật modules với lesson đã gắn tracking
        const updatedModules = course.modules.map((m) => ({
          ...m,
          lessons: updatedLessons.filter((l) =>
            m.lessons.some((x) => x.id === l.id)
          ),
        }));

        setCourse({ ...course, modules: updatedModules });
      } catch (err) {
        console.error("Không thể tải tracking:", err);
      }
    };

    fetchAllTracking();
  }, [course, trackingLoaded]);

  useEffect(() => {
    if (!currentLesson?.video_url) return;

    const videoId = getYouTubeId(currentLesson.video_url);
    let playerInstance = null;
    let maxPlayed = 0;
    let intervalId = null;

    if (videoId) {
      if (!window.YT) {
        const tag = document.createElement("script");
        tag.src = "https://www.youtube.com/iframe_api";
        document.body.appendChild(tag);
      }

      const createPlayer = () => {
        playerInstance = new window.YT.Player("youtube-player", {
          videoId,
          events: {
            onReady: (e) => {
              if (tracking?.last_position) {
                e.target.seekTo(tracking.last_position, true);
                maxPlayed = tracking.last_position;
              }
            },
            onStateChange: async (event) => {
              if (!playerInstance?.getCurrentTime) return;

              if (event.data === window.YT.PlayerState.PLAYING) {
                const duration = playerInstance.getDuration();

                if (intervalId) clearInterval(intervalId);

                intervalId = setInterval(async () => {
                  if (!playerInstance?.getCurrentTime) return;
                  const current = playerInstance.getCurrentTime();

                  if (current > maxPlayed + 5) {
                    maxPlayed = current;
                    try {
                      await axios.post("/api/lesson-tracking/update", {
                        lesson_id: currentLesson.id,
                        last_position: Math.floor(current),
                        duration: Math.floor(duration),
                      });
                    } catch (err) {
                      console.error("Không thể cập nhật tiến trình:", err);
                    }
                  }
                }, 8000);
              }

              if (event.data === window.YT.PlayerState.ENDED) {
                if (intervalId) clearInterval(intervalId);
                const current = playerInstance.getCurrentTime();
                const duration = playerInstance.getDuration();

                try {
                  await axios.post("/api/lesson-tracking/update", {
                    lesson_id: currentLesson.id,
                    last_position: Math.floor(duration),
                    duration: Math.floor(duration),
                    is_completed: true, 
                  });

                  const allLessons = course.modules.flatMap((m) => m.lessons);
                  const index = allLessons.findIndex(
                    (l) => l.id === currentLesson.id
                  );
                  if (index >= 0 && index < allLessons.length - 1) {
                    const nextLesson = allLessons[index + 1];
                    const updatedModules = course.modules.map((m) => ({
                      ...m,
                      lessons: m.lessons.map((l) =>
                        l.id === nextLesson.id ? { ...l, is_locked: false } : l
                      ),
                    }));
                    setCourse({ ...course, modules: updatedModules });
                  }
                } catch (err) {
                  console.error("Không thể cập nhật hoàn tất:", err);
                }
              }
            },
          },
        });
      };

      if (window.YT?.Player) {
        createPlayer();
      } else {
        window.onYouTubeIframeAPIReady = createPlayer;
      }
    }

    return () => {
      if (intervalId) clearInterval(intervalId);
      if (playerInstance?.destroy) playerInstance.destroy();

      const playerEl = document.getElementById("youtube-player");
      if (playerEl) playerEl.innerHTML = "";
    };
  }, [currentLesson, tracking]);

  if (loading)
    return (
      <div className="d-flex justify-content-center py-5">
        <div className="spinner-border text-primary" role="status"></div>
      </div>
    );

  if (!course)
    return <p className="text-center py-5">Không tìm thấy khóa học</p>;

  const getYouTubeId = (url) => {
    const regExp =
      /^.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|watch\?.+&v=)([^#&?]*).*/;
    const match = url.match(regExp);
    return match && match[1].length === 11 ? match[1] : null;
  };

  const toggleModule = (id) => {
    setOpenModules((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const allLessons = course.modules?.flatMap((m) => m.lessons) || [];

  // Số bài đã học = số bài có tracking và is_completed = true
  const learnedLessons = allLessons.filter(
    (l) => l.tracking?.is_completed
  ).length;

  // Tổng số bài
  const totalLessons = allLessons.length;

  // Phần trăm bài học đã học
  const percent =
    totalLessons > 0 ? Math.round((learnedLessons / totalLessons) * 100) : 0;

  const handlePrevNext = (direction) => {
    const flatLessons = course.modules.flatMap((m) => m.lessons);
    const index = flatLessons.findIndex((l) => l.id === currentLesson.id);
    if (direction === "prev" && index > 0)
      setCurrentLesson(flatLessons[index - 1]);
    else if (direction === "next" && index < flatLessons.length - 1)
      setCurrentLesson(flatLessons[index + 1]);
  };

  return (
    <div className="container-fluid p-0 position-relative">
      <div className="d-flex justify-content-between align-items-center bg-dark text-white px-4 py-2 sticky-top shadow-sm">
        <div
          className="d-flex align-items-center gap-2"
          style={{ cursor: "pointer" }}
          onClick={() => router.push("/")}
        >
          <ArrowLeftOutlined />
          <span className="fw-semibold">Quay lại</span>
        </div>

        <div className="d-flex align-items-center gap-4">
          <div className="d-flex align-items-center gap-2">
            <Progress
              type="circle"
              percent={percent}
              size={40}
              strokeColor={percent === 0 ? "#d9d9d9" : "#0d6efd"} // màu khác khi 0%
              trailColor={percent === 0 ? "#d9d9d9" : "#e6f0ff"}
              strokeWidth={6}
              format={(p) => (
                <span style={{ color: "#d9d9d9", fontWeight: "bold" }}>
                  {p}%
                </span>
              )}
            />
            <span style={{ color: "#ffffffff", fontWeight: "500" }}>
              {learnedLessons}/{totalLessons} bài học
            </span>
          </div>

          <button className="btn btn-outline-light btn-sm">
            <FileTextOutlined className="me-1" />
            Ghi chú
          </button>
        </div>
      </div>

      <div className="row g-0" style={{ paddingBottom: "80px" }}>
        <div className="col-lg-9 p-4 bg-light">
          <div
            className="ratio ratio-16x9 bg-black rounded overflow-hidden d-flex align-items-center justify-content-center"
            style={{ minHeight: "420px" }}
          >
            {currentLesson?.video_url ? (
              currentLesson.video_url.includes("youtube.com") ||
              currentLesson.video_url.includes("youtu.be") ? (
                <div id="youtube-player" className="w-100 h-100"></div>
              ) : (
                <video
                  key={currentLesson.id}
                  src={currentLesson.video_url}
                  controls
                  onTimeUpdate={async (e) => {
                    const current = e.target.currentTime;
                    const duration = e.target.duration;

                    if (current > (e.target.maxPlayed || 0) + 5) {
                      e.target.maxPlayed = current;

                      try {
                        await axios.post("/api/lesson-tracking/update", {
                          lesson_id: currentLesson.id,
                          last_position: Math.floor(current),
                          duration: Math.floor(duration),
                        });
                      } catch (err) {
                        console.error("Không thể cập nhật tiến trình:", err);
                      }
                    }
                  }}
                  onLoadedMetadata={(e) => {
                    if (tracking?.last_position) {
                      e.target.currentTime = tracking.last_position;
                      e.target.maxPlayed = tracking.last_position;
                    }
                  }}
                  className="w-100 h-100 object-fit-contain"
                />
              )
            ) : (
              <PlayCircleOutlined
                style={{ fontSize: "4rem", color: "#0d6efd" }}
              />
            )}
          </div>

          <h4 className="mt-3">{currentLesson?.name}</h4>
        </div>

        <div
          className="col-lg-3 border-start p-3 bg-white"
          style={{
            maxHeight: "calc(100vh - 56px)",
            overflowY: "auto",
          }}
        >
          <h5 className="fw-bold mb-3">Nội dung khóa học</h5>
          {course.modules?.map((module, idx) => (
            <div key={module.id} className="mb-3 border rounded">
              <div
                className="d-flex justify-content-between align-items-center bg-primary text-white px-3 py-2 rounded-top"
                style={{ cursor: "pointer" }}
                onClick={() => toggleModule(module.id)}
              >
                <span>
                  {idx + 1}. {module.name}
                </span>
                {openModules[module.id] ? <DownOutlined /> : <RightOutlined />}
              </div>

              {openModules[module.id] && (
                <ul className="list-unstyled mb-0 px-2 py-2">
                  {module.lessons?.map((lesson) => (
                    <li
                      key={lesson.id}
                      className={`py-2 px-2 rounded mb-1 d-flex align-items-center justify-content-between ${
                        currentLesson?.id === lesson.id
                          ? "bg-primary text-white"
                          : lesson.is_locked
                          ? "bg-light text-muted"
                          : "bg-light"
                      }`}
                      style={{
                        cursor: lesson.is_locked ? "not-allowed" : "pointer",
                        opacity: lesson.is_locked ? 0.6 : 1,
                      }}
                      onClick={() => {
                        if (lesson.is_locked) {
                          message.warning(
                            " Bạn cần hoàn thành bài học trước để mở bài này!"
                          );
                          return;
                        }
                        setCurrentLesson(lesson);
                      }}
                    >
                      <div>
                        <PlayCircleOutlined className="me-2" />
                        {lesson.name}
                      </div>

                      {lesson.is_locked && (
                        <span
                          className="ms-2 badge bg-secondary"
                          style={{ fontSize: "0.75rem" }}
                        >
                          Khóa
                        </span>
                      )}
                    </li>
                  ))}
                </ul>
              )}
            </div>
          ))}
        </div>
      </div>

      <div
        className="d-flex justify-content-center gap-3 bg-white py-3 border-top shadow-sm w-100 position-fixed bottom-0"
        style={{ zIndex: 1050 }}
      >
        <button
          className="btn btn-outline-secondary px-4"
          onClick={() => handlePrevNext("prev")}
        >
          Bài trước
        </button>
        <button
          className="btn btn-primary px-4"
          onClick={() => handlePrevNext("next")}
        >
          Bài tiếp theo
        </button>
      </div>
    </div>
  );
}
