"use client";
import { useSearchParams, useParams } from "next/navigation";
import CourseDetailPage from "./CourseDetailPage";
import CoursePlayer from "./CoursePlayer";

export default function CoursePage() {
  const { slug } = useParams();
  const searchParams = useSearchParams();
  const courseHash = searchParams.get("id");

  if (courseHash) {
    return <CoursePlayer slug={slug} courseHash={courseHash} />;
  }

  return <CourseDetailPage />;
}
