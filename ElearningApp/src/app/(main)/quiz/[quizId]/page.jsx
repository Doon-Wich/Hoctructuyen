"use client";

import QuizModule from "@/components/QuizModule";
import { useParams } from "next/navigation";

export default function QuizPage() {
  const params = useParams();
  const quizId = params.quizId;

  return <QuizModule quizId={quizId} />;
}
