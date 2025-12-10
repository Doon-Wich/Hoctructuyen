"use client";

import { Upload, Button, message } from "antd";
import { UploadOutlined } from "@ant-design/icons";
import "@ant-design/v5-patch-for-react-19";
import { useEffect, useState } from "react";
import axios from "@/utils/axios";

export default function FileUpload({ folder = "uploads", onChange, initialValue }) {
  const [fileList, setFileList] = useState([]);

  useEffect(() => {
    if (initialValue) {

      const fullUrl = initialValue.startsWith("http")
        ? initialValue
        : `${process.env.NEXT_PUBLIC_API_URL.replace(/\/$/, "")}${initialValue}`;

      setFileList([
        {
          uid: "-1",
          name: fullUrl.split("/").pop(),
          status: "done",
          url: fullUrl,
        },
      ]);
    } else {
      setFileList([]);
    }
  }, [initialValue]);

  const handleChange = ({ file, fileList }) => {
    setFileList(fileList);

    if (file.status === "done") {
      message.success(`${file.name} tải lên thành công!`);

      const uploadedUrl = file.response.data.url.startsWith("http")
        ? file.response.data.url
        : `${process.env.NEXT_PUBLIC_API_URL.replace(/\/$/, "")}${file.response.data.url}`;

      onChange && onChange(uploadedUrl);
    } else if (file.status === "error") {
      message.error(`${file.name} tải lên thất bại.`);
    }
  };

  const customRequest = async ({ file, onSuccess, onError }) => {
    const formData = new FormData();
    formData.append("file", file);
    formData.append("folder", folder);

    try {
      const res = await axios.post("/api/upload-file", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });
      onSuccess(res.data);
    } catch (err) {
      console.error(err);
      onError(err);
    }
  };

  return (
    <Upload
      customRequest={customRequest}
      onChange={handleChange}
      fileList={fileList}
      maxCount={1}
    >
      <Button icon={<UploadOutlined />}>Tải file lên</Button>
    </Upload>
  );
}
