"use client";

import CodeMirror from "@uiw/react-codemirror";
import { javascript } from "@codemirror/lang-javascript";

import { tokyoNight } from "@uiw/codemirror-theme-tokyo-night";
import { dracula } from "@uiw/codemirror-theme-dracula";
import { githubLight } from "@uiw/codemirror-theme-github";

export default function CodeEditor({
  value,
  onChange,
  theme = "tokyo", 
}) {
  const themeMap = {
    tokyo: tokyoNight,
    dracula: dracula,
    github: githubLight,
  };

  return (
    <CodeMirror
      value={value || ""}
      height="350px"
      theme={themeMap[theme]}
      extensions={[javascript()]}
      onChange={(val) => onChange(val)}
      style={{
        borderRadius: "8px",
        overflow: "hidden",
        border: "1px solid #e3e3e3",
      }}
    />
  );
}
