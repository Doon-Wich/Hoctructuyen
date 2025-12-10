import AdminWrapper from "@/components/AdminWrapper";

import '@/styles/admin.css';  
export const metadata = {
  title: "Admin Panel",
};

export default function AdminLayout({ children }) {
  return <AdminWrapper>{children}</AdminWrapper>;
}
