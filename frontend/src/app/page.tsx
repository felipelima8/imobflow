"use client";

import React, { useState, useEffect } from "react";

export default function Home() {
  const [activeStep, setActiveStep] = useState(2);
  const [apiStatus, setApiStatus] = useState<"loading" | "online" | "offline">("loading");

  useEffect(() => {
    // Check backend health
    fetch("http://localhost:8080/actuator/health")
      .then((res) => {
        if (res.ok) setApiStatus("online");
        else setApiStatus("offline");
      })
      .catch(() => setApiStatus("offline"));
  }, []);

  const timelineSteps = [
    { number: 1, title: "Imóvel Escolhido", desc: "Apartamento Jardins - R$ 850.000", status: "completed" },
    { number: 2, title: "Envio de Documentos", desc: "RG, CPF e Comprovante de Renda", status: "completed" },
    { number: 3, title: "Análise Cadastral e Risco", desc: "IA Engine processando certidões", status: "active" },
    { number: 4, title: "Simulação e Crédito", desc: "Cenários de financiamento multi-banco", status: "pending" },
    { number: 5, title: "Escritura & Chaves", desc: "Assinatura do contrato de compra e venda", status: "pending" },
  ];

  return (
    <div className="animate-fade-in" style={{ padding: "2rem", maxWidth: "1200px", margin: "0 auto" }}>
      {/* Header */}
      <header style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "4rem" }}>
        <div style={{ display: "flex", alignItems: "center", gap: "0.75rem" }}>
          <div style={{
            width: "40px",
            height: "40px",
            background: "linear-gradient(135deg, var(--color-accent), var(--color-secondary))",
            borderRadius: "var(--radius-sm)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontWeight: "bold",
            fontSize: "1.25rem",
            color: "white"
          }}>IF</div>
          <h1 style={{ fontSize: "1.5rem", fontWeight: "800", background: "linear-gradient(to right, #fff, var(--text-secondary))", WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent" }}>ImobFlow</h1>
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}>
          <span style={{
            width: "8px",
            height: "8px",
            borderRadius: "50%",
            backgroundColor: apiStatus === "online" ? "var(--color-success)" : apiStatus === "offline" ? "var(--color-danger)" : "var(--color-warning)"
          }}></span>
          <span style={{ fontSize: "0.85rem", color: "var(--text-secondary)", textTransform: "uppercase", letterSpacing: "0.05em" }}>
            Backend: {apiStatus}
          </span>
        </div>
      </header>

      {/* Hero Section */}
      <section style={{ textAlign: "center", marginBottom: "5rem" }}>
        <span style={{
          background: "rgba(99, 102, 241, 0.1)",
          border: "1px solid rgba(99, 102, 241, 0.2)",
          padding: "0.5rem 1rem",
          borderRadius: "var(--radius-full)",
          fontSize: "0.85rem",
          fontWeight: "600",
          color: "var(--color-accent)",
          display: "inline-block",
          marginBottom: "1.5rem"
        }}>
          🚀 Proposta de Valor Exclusiva — O Comprador no Centro
        </span>
        <h2 style={{ fontSize: "3.5rem", lineHeight: "1.1", marginBottom: "1.5rem", fontWeight: "800" }}>
          A jornada de compra de imóveis,<br />
          <span style={{ background: "linear-gradient(to right, var(--color-accent), var(--color-secondary))", WebkitBackgroundClip: "text", WebkitTextFillColor: "transparent" }}>
            descomplicada e guiada por IA.
          </span>
        </h2>
        <p style={{ color: "var(--text-secondary)", fontSize: "1.15rem", maxWidth: "650px", margin: "0 auto 2.5rem auto", lineHeight: "1.6" }}>
          Substitua planilhas e e-mails por uma timeline transparente e interativa. Economize tempo de corretores e advogados usando inteligência artificial.
        </p>
        <div style={{ display: "flex", gap: "1rem", justifyContent: "center" }}>
          <button className="btn btn-primary" onClick={() => window.open("/api-docs", "_blank")}>Documentação da API</button>
          <button className="btn btn-secondary">Acessar Painel do Corretor</button>
        </div>
      </section>

      {/* Interactive Journey Demo */}
      <section className="card" style={{ marginBottom: "5rem", padding: "2.5rem" }}>
        <h3 style={{ fontSize: "1.5rem", marginBottom: "2rem", display: "flex", alignItems: "center", gap: "0.5rem" }}>
          📍 Timeline da Jornada do Comprador
        </h3>
        
        <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))", gap: "1.5rem" }}>
          {timelineSteps.map((step, idx) => {
            const isActive = idx === activeStep;
            const isCompleted = idx < activeStep;
            return (
              <div 
                key={step.number} 
                className="card"
                onClick={() => setActiveStep(idx)}
                style={{
                  background: isActive ? "rgba(99, 102, 241, 0.08)" : "var(--glass-bg)",
                  borderColor: isActive ? "var(--color-accent)" : isCompleted ? "rgba(16, 185, 129, 0.3)" : "var(--glass-border)",
                  cursor: "pointer",
                  padding: "1.25rem",
                  transition: "all 0.3s ease"
                }}
              >
                <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1rem" }}>
                  <span style={{
                    width: "28px",
                    height: "28px",
                    borderRadius: "50%",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    fontSize: "0.85rem",
                    fontWeight: "bold",
                    background: isActive 
                      ? "var(--color-accent)" 
                      : isCompleted 
                        ? "var(--color-success)" 
                        : "var(--bg-tertiary)",
                    color: "white"
                  }}>
                    {isCompleted ? "✓" : step.number}
                  </span>
                  <span style={{
                    fontSize: "0.75rem",
                    fontWeight: "600",
                    textTransform: "uppercase",
                    color: isActive 
                      ? "var(--color-accent)" 
                      : isCompleted 
                        ? "var(--color-success)" 
                        : "var(--text-muted)"
                  }}>
                    {isActive ? "Em Foco" : isCompleted ? "Concluído" : "Aguardando"}
                  </span>
                </div>
                <h4 style={{ fontSize: "1rem", marginBottom: "0.5rem" }}>{step.title}</h4>
                <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", lineHeight: "1.4" }}>{step.desc}</p>
              </div>
            );
          })}
        </div>
      </section>

      {/* System Features */}
      <section style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "2rem" }}>
        <div className="card">
          <h3 style={{ fontSize: "1.25rem", marginBottom: "1rem", color: "var(--color-accent)" }}>🤖 AI Engine Integrado</h3>
          <p style={{ color: "var(--text-secondary)", fontSize: "0.95rem", lineHeight: "1.6", marginBottom: "1rem" }}>
            Mapeado com base no motor do PlantaAI, o `ai-engine` gerencia OCR de documentos, cálculo de compatibilidade, chatbot de atendimento e análise automatizada de risco.
          </p>
          <div style={{ display: "flex", gap: "0.5rem", flexWrap: "wrap" }}>
            <span style={{ background: "var(--bg-tertiary)", padding: "0.25rem 0.75rem", borderRadius: "var(--radius-full)", fontSize: "0.8rem" }}>Python 3.12</span>
            <span style={{ background: "var(--bg-tertiary)", padding: "0.25rem 0.75rem", borderRadius: "var(--radius-full)", fontSize: "0.8rem" }}>FastAPI</span>
            <span style={{ background: "var(--bg-tertiary)", padding: "0.25rem 0.75rem", borderRadius: "var(--radius-full)", fontSize: "0.8rem" }}>RabbitMQ</span>
          </div>
        </div>

        <div className="card">
          <h3 style={{ fontSize: "1.25rem", marginBottom: "1rem", color: "var(--color-secondary)" }}>🔒 Segurança Multitenant (RLS)</h3>
          <p style={{ color: "var(--text-secondary)", fontSize: "0.95rem", lineHeight: "1.6", marginBottom: "1rem" }}>
            Isolamento total dos dados de clientes, imóveis e jornadas por imobiliária. O PostgreSQL 16 aplica Row Level Security no nível do banco de dados para proteção robusta.
          </p>
          <div style={{ display: "flex", gap: "0.5rem", flexWrap: "wrap" }}>
            <span style={{ background: "var(--bg-tertiary)", padding: "0.25rem 0.75rem", borderRadius: "var(--radius-full)", fontSize: "0.8rem" }}>PostgreSQL 16</span>
            <span style={{ background: "var(--bg-tertiary)", padding: "0.25rem 0.75rem", borderRadius: "var(--radius-full)", fontSize: "0.8rem" }}>Spring Modulith</span>
            <span style={{ background: "var(--bg-tertiary)", padding: "0.25rem 0.75rem", borderRadius: "var(--radius-full)", fontSize: "0.8rem" }}>Keycloak</span>
          </div>
        </div>
      </section>
    </div>
  );
}
