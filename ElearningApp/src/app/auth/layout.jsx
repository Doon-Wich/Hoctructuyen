export default function AuthLayout({ children }) {
  return (
    <div className="d-flex align-items-center justify-content-center min-vh-100 bg-light">
      <div className="card shadow rounded-4 p-4" style={{ width: "500px" }}>
        <h1 className="h4 text-center mb-4 text-primary fw-bold">
            Xin chào
        </h1>
        {children}
      </div>
    </div>
  );
}
