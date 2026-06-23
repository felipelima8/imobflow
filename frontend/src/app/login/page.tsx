"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const [email, setEmail] = useState("felipemjl08@gmail.com");
  const [password, setPassword] = useState("123456");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    setTimeout(() => {
      // Mock validation
      if (email === "felipemjl08@gmail.com") {
        localStorage.setItem("userRole", "client");
        localStorage.setItem("imobflow_tenant_id", "00000000-0000-0000-0000-000000000003");
      } else {
        localStorage.setItem("userRole", "broker");
        localStorage.setItem("imobflow_tenant_id", "00000000-0000-0000-0000-000000000001");
      }
      
      router.push("/");
    }, 1500);
  };

  return (
    <div style={{
      minHeight: "100vh",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
      background: "var(--bg-primary)"
    }}>
      <div className="card animate-fade-in" style={{ width: "100%", maxWidth: "420px", padding: "3rem" }}>
        <div style={{ textAlign: "center", marginBottom: "2rem" }}>
          <h1 style={{ fontFamily: "var(--font-title)", fontSize: "2rem", color: "white", marginBottom: "0.5rem" }}>
            <span style={{ color: "var(--color-accent)" }}>Imob</span>Flow
          </h1>
          <p style={{ color: "var(--text-secondary)", fontSize: "0.9rem" }}>
            Acesse o seu portal de acompanhamento
          </p>
        </div>

        <form onSubmit={handleLogin} style={{ display: "flex", flexDirection: "column", gap: "1.25rem" }}>
          <div className="input-group">
            <label className="label">E-mail</label>
            <input 
              type="email" 
              className="input" 
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="input-group">
            <label className="label">Senha</label>
            <input 
              type="password" 
              className="input" 
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          <button 
            type="submit" 
            className="btn btn-primary" 
            style={{ marginTop: "1rem", position: "relative" }}
            disabled={loading}
          >
            {loading ? "Autenticando..." : "Entrar"}
          </button>
        </form>

        <div style={{ textAlign: "center", marginTop: "2rem", fontSize: "0.8rem", color: "var(--text-muted)" }}>
          Simulação de acesso: felipemjl08@gmail.com<br/>(Acesso Cliente / Comprador)
        </div>
      </div>
    </div>
  );
}
