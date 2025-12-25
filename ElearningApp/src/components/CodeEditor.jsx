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
  readOnly = false,
}) {
  const themeMap = {
    tokyo: tokyoNight,
    dracula: dracula,
    github: githubLight,
  };

  return (
    <CodeMirror
      value={value || ""}
      theme={themeMap[theme]}
      extensions={[javascript()]}
      onChange={(val) => onChange && onChange(val)}
      readOnly={readOnly}
      height="350px"
      style={{
        borderRadius: "8px",
        overflow: "hidden",
        border: "1px solid #e3e3e3",
        fontFamily: "monospace",
        fontSize: "0.95rem",
        whiteSpace: "pre-wrap",
        wordBreak: "break-word",
        overflowWrap: "break-word",
      }}
      basicSetup={{
        lineNumbers: true,
        foldGutter: true,
        highlightSelectionMatches: true,
        bracketMatching: true,
        closeBrackets: true,
        autocompletion: true,
        history: true,
        defaultKeymap: true,
        lineWrapping: true, // <<< đây là quan trọng
      }}
    />
  );
}
