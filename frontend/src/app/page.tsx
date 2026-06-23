"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { api, Customer, Property, Journey, TimelineEvent, Proposal, DocumentFile } from "../lib/api";

const TENANTS = [
  { id: "00000000-0000-0000-0000-000000000001", name: "Acme Real Estate (Tenant 1)" },
  { id: "00000000-0000-0000-0000-000000000002", name: "ImobCorp SaaS (Tenant 2)" },
  { id: "00000000-0000-0000-0000-000000000003", name: "WFJ Imóveis (Tenant 3)" },
];

export default function Home() {
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<"customers" | "properties" | "journeys">("customers");
  const [tenant, setTenant] = useState("");
  const [apiStatus, setApiStatus] = useState<"loading" | "online" | "offline">("loading");

  // Domain Lists
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [properties, setProperties] = useState<Property[]>([]);
  const [journeys, setJourneys] = useState<Journey[]>([]);

  // Selected Journey for Detail/Timeline View
  const [selectedJourney, setSelectedJourney] = useState<Journey | null>(null);
  const [timelineEvents, setTimelineEvents] = useState<TimelineEvent[]>([]);
  const [proposals, setProposals] = useState<Proposal[]>([]);
  const [loadingDetails, setLoadingDetails] = useState(false);
  const [completedLocalSteps, setCompletedLocalSteps] = useState<number[]>([]);
  const [uploadedDocuments, setUploadedDocuments] = useState<DocumentFile[]>([]);
  const [uploadingFile, setUploadingFile] = useState(false);
  const [userRole, setUserRole] = useState<"broker" | "client">("broker");
  const [showDiscountModal, setShowDiscountModal] = useState(false);
  const [discountAnalyzing, setDiscountAnalyzing] = useState(false);
  const [discountResult, setDiscountResult] = useState<any>(null);

  const toggleLocalStep = (stepNum: number) => {
    setCompletedLocalSteps(prev => 
      prev.includes(stepNum) ? prev.filter(s => s !== stepNum) : [...prev, stepNum]
    );
  };

  // Forms State
  const [customerForm, setCustomerForm] = useState({ name: "", email: "", phone: "", cpf: "", monthlyIncome: 5000, fgtsBalance: 20000 });
  const [propertyForm, setPropertyForm] = useState({ title: "", type: "APARTMENT", price: 350000, bedrooms: 2, addressCity: "São Paulo" });
  const [journeyForm, setJourneyForm] = useState({ customerId: "", propertyId: "" });

  const [notification, setNotification] = useState<{ message: string; type: "success" | "error" } | null>(null);

  // Initialize Tenant
  useEffect(() => {
    if (typeof window !== "undefined") {
      const role = localStorage.getItem("userRole");
      if (!role) {
        router.push("/login");
        return;
      }
      setUserRole(role as "broker" | "client");

      const stored = localStorage.getItem("imobflow_tenant_id") || TENANTS[0].id;
      setTenant(stored);
      localStorage.setItem("imobflow_tenant_id", stored);

      if (role === "client") {
        api.journeys.list("00000000-0000-0000-0000-000000000007").then(journeyList => {
          const felipeJourney = journeyList.content?.find(j => j.id === "00000000-0000-0000-0000-000000000060");
          if (felipeJourney) setSelectedJourney(felipeJourney);
          else if (journeyList.content && journeyList.content.length > 0) setSelectedJourney(journeyList.content[0]);
        }).catch(console.error);
      }
    }
  }, [router]);

  // Fetch Data when Tenant or active tab changes
  useEffect(() => {
    if (!tenant) return;

    // Check backend health first
    fetch("http://localhost:8080/actuator/health")
      .then((res) => {
        if (res.ok) setApiStatus("online");
        else setApiStatus("offline");
      })
      .catch(() => setApiStatus("offline"));

    refreshData();
  }, [tenant]);

  // Load selected journey's timeline and proposals
  useEffect(() => {
    setCompletedLocalSteps([]);
    if (!selectedJourney) {
      setTimelineEvents([]);
      setProposals([]);
      setUploadedDocuments([]);
      return;
    }

    const fetchJourneyDetails = async () => {
      setLoadingDetails(true);
      try {
        const events = await api.journeys.getTimeline(selectedJourney.id);
        // Let's sort them in ascending order of creation for the UI display, or descending depending on how we render.
        // We will sort them by date (ascending) so the story unfolds naturally.
        const sortedEvents = [...events].sort(
          (a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
        );
        setTimelineEvents(sortedEvents);

        const props = await api.journeys.getProposals(selectedJourney.id);
        setProposals(props);

        const docs = await api.documents.list(selectedJourney.id);
        setUploadedDocuments(docs);
      } catch (err) {
        console.error("Error fetching journey details:", err);
      } finally {
        setLoadingDetails(false);
      }
    };

    fetchJourneyDetails();
  }, [selectedJourney]);

  const refreshData = async () => {
    try {
      const custData = await api.customers.list();
      setCustomers(custData.content || []);

      const propData = await api.properties.list();
      setProperties(propData.content || []);

      // Mock broker ID for demo purposes
      const mockBrokerId = tenant === "00000000-0000-0000-0000-000000000001"
        ? "00000000-0000-0000-0000-000000000009"
        : tenant === "00000000-0000-0000-0000-000000000002"
        ? "00000000-0000-0000-0000-000000000008"
        : "00000000-0000-0000-0000-000000000007";
      const journeyData = await api.journeys.list(mockBrokerId);
      const list = journeyData.content || [];
      setJourneys(list);
      
      if (list.length > 0) {
        setSelectedJourney((prev) => {
          if (prev) {
            const found = list.find((j) => j.id === prev.id);
            if (found) return found;
          }
          return list[0];
        });
      } else {
        setSelectedJourney(null);
      }
    } catch (err: any) {
      console.error("Error loading data:", err.message);
    }
  };

  const showToast = (message: string, type: "success" | "error" = "success") => {
    setNotification({ message, type });
    setTimeout(() => setNotification(null), 4000);
  };

  const handleLogout = () => {
    localStorage.removeItem("userRole");
    localStorage.removeItem("imobflow_tenant_id");
    router.push("/login");
  };

  const handleDiscountAnalysis = () => {
    setShowDiscountModal(true);
    setDiscountAnalyzing(true);
    setDiscountResult(null);
    setTimeout(() => {
      setDiscountResult({
        itbiExemption: false,
        itbiReason: "Imóvel acima de R$123.945,02 (teto SFH/MCMV para isenção em SP). ITBI de 3% mantido.",
        firstPropertyDiscount: true,
        firstPropertyLaw: "Lei 6.015/73, Art. 290 — Registros Públicos",
        originalEscritura: 3200.00,
        discountedEscritura: 1600.00,
        originalRegistro: 2517.00,
        discountedRegistro: 1258.50,
        originalTotal: 13277.00,
        newTotal: 10435.50,
        savings: 2841.50,
        requirements: [
          "Declaração de que é o primeiro imóvel residencial do comprador",
          "Certidão negativa de propriedade nos CRIs da comarca",
          "Comprovante de residência atualizado",
          "Cópia do RG e CPF"
        ],
        legalBasis: [
          { law: "Lei 6.015/73, Art. 290", desc: "50% de desconto nos emolumentos de registro para primeira aquisição de imóvel residencial financiado pelo SFH" },
          { law: "Lei 9.934/97", desc: "Estende o desconto a escrituras públicas de primeira aquisição" },
          { law: "Decreto Municipal SP 46.228/05", desc: "ITBI: isenção apenas para imóveis até R$123.945,02 em programas habitacionais" }
        ]
      });
      setDiscountAnalyzing(false);
    }, 2500);
  };

  const handleUploadDocument = async (e: React.ChangeEvent<HTMLInputElement>, title: string, type: string) => {
    if (!selectedJourney || !e.target.files || e.target.files.length === 0) return;
    const file = e.target.files[0];
    setUploadingFile(true);
    try {
      const uploaded = await api.documents.upload(selectedJourney.id, title, type, file);
      setUploadedDocuments(prev => [...prev, uploaded]);
      showToast("Documento enviado e processado com sucesso!");
    } catch (err: any) {
      console.error(err);
      showToast("Erro ao enviar o documento. Tente novamente.", "error");
    } finally {
      setUploadingFile(false);
    }
  };

  // Submit Customer
  const handleCreateCustomer = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const created = await api.customers.create({
        ...customerForm,
        status: "LEAD",
      });
      setCustomers([...customers, created]);
      setCustomerForm({ name: "", email: "", phone: "", cpf: "", monthlyIncome: 5000, fgtsBalance: 20000 });
      showToast("Cliente criado com sucesso!");
      refreshData();
    } catch (err: any) {
      showToast(err.message, "error");
    }
  };

  // Submit Property
  const handleCreateProperty = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const created = await api.properties.create({
        ...propertyForm,
        status: "AVAILABLE",
      });
      setProperties([...properties, created]);
      setPropertyForm({ title: "", type: "APARTMENT", price: 350000, bedrooms: 2, addressCity: "São Paulo" });
      showToast("Imóvel cadastrado com sucesso!");
      refreshData();
    } catch (err: any) {
      showToast(err.message, "error");
    }
  };

  // Submit Journey
  const handleCreateJourney = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!journeyForm.customerId) {
      showToast("Por favor, selecione um cliente", "error");
      return;
    }
    try {
      const mockBrokerId = tenant === "00000000-0000-0000-0000-000000000001"
        ? "00000000-0000-0000-0000-000000000009"
        : tenant === "00000000-0000-0000-0000-000000000002"
        ? "00000000-0000-0000-0000-000000000008"
        : "00000000-0000-0000-0000-000000000007";
      const created = await api.journeys.create({
        customerId: journeyForm.customerId,
        propertyId: journeyForm.propertyId || undefined,
        brokerId: mockBrokerId,
      });
      setJourneys([...journeys, created]);
      setSelectedJourney(created);
      setJourneyForm({ customerId: "", propertyId: "" });
      showToast("Jornada de compra iniciada!");
      refreshData();
    } catch (err: any) {
      showToast(err.message, "error");
    }
  };

  const handleUpdateJourneyStatus = async (id: string, nextStatus: string) => {
    try {
      const updated = await api.journeys.updateStatus(id, nextStatus);
      setJourneys(journeys.map(j => j.id === id ? updated : j));
      if (selectedJourney?.id === id) {
        setSelectedJourney(updated);
      }
      showToast(`Status da jornada atualizado para ${nextStatus}`);
    } catch (err: any) {
      showToast(err.message, "error");
    }
  };

  // Helper for timeline rendering
  const getTimelineSteps = (status: string) => {
    const steps = [
      { num: 1, title: "Jornada Iniciada", active: true },
      { num: 2, title: "Análise Cadastral (IA)", active: ["ANALYSIS", "FINANCING_APPROVED", "COMPLETED"].includes(status) },
      { num: 3, title: "Crédito Aprovado", active: ["FINANCING_APPROVED", "COMPLETED"].includes(status) },
      { num: 4, title: "Contrato Assinado", active: ["COMPLETED"].includes(status) },
    ];
    return steps;
  };

  return (
    <div className="animate-fade-in" style={{ padding: "2rem", maxWidth: "1200px", margin: "0 auto" }}>
      {/* Toast Notification */}
      {notification && (
        <div style={{
          position: "fixed",
          top: "20px",
          right: "20px",
          padding: "1rem 1.5rem",
          borderRadius: "var(--radius-md)",
          background: notification.type === "success" ? "var(--color-success)" : "var(--color-danger)",
          color: "white",
          zIndex: 1000,
          boxShadow: "var(--shadow-lg)",
          fontWeight: "bold",
          animation: "fadeIn 0.2s ease"
        }}>
          {notification.message}
        </div>
      )}

      {/* Header */}
      <header style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "3rem", flexWrap: "wrap", gap: "1rem" }}>
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
          <div>
            <h1 style={{ fontSize: "1.5rem", fontWeight: "800" }}>ImobFlow</h1>
            <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>SaaS Multi-tenant Real Estate Dashboard</p>
          </div>
        </div>

        {/* Role and Tenant Selector */}
        <div style={{ display: "flex", alignItems: "center", gap: "1.5rem", flexWrap: "wrap" }}>
          
          <div style={{ display: "flex", flexDirection: "column", gap: "0.25rem", alignItems: "flex-end" }}>
            <span className="label" style={{ marginBottom: "0.5rem" }}>
              Logado como: <strong style={{ color: "white" }}>{userRole === "client" ? "Felipe (Cliente)" : "Corretor"}</strong>
            </span>
            <button 
              onClick={handleLogout}
              className="btn btn-secondary"
              style={{ padding: "0.4rem 1rem", fontSize: "0.8rem", borderRadius: "var(--radius-sm)" }}
            >
              Sair / Logout
            </button>
          </div>

          <div style={{ display: "flex", alignItems: "center", gap: "0.5rem", alignSelf: "flex-end", height: "40px" }}>
            <span style={{
              width: "8px",
              height: "8px",
              borderRadius: "50%",
              backgroundColor: apiStatus === "online" ? "var(--color-success)" : apiStatus === "offline" ? "var(--color-danger)" : "var(--color-warning)"
            }}></span>
            <span style={{ fontSize: "0.85rem", color: "var(--text-secondary)", textTransform: "uppercase" }}>
              API: {apiStatus}
            </span>
          </div>
        </div>
      </header>

      {userRole === "broker" ? (
        <>
          {/* Tabs */}
          <div style={{ display: "flex", gap: "1rem", marginBottom: "2rem", borderBottom: "1px solid var(--glass-border)", paddingBottom: "0.5rem" }}>
            {(["customers", "properties", "journeys"] as const).map(tab => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                style={{
                  background: "none",
                  border: "none",
                  color: activeTab === tab ? "var(--color-accent)" : "var(--text-secondary)",
                  fontSize: "1.1rem",
                  fontWeight: "600",
                  cursor: "pointer",
                  padding: "0.5rem 1rem",
                  borderBottom: activeTab === tab ? "2px solid var(--color-accent)" : "none",
                  textTransform: "capitalize",
                  transition: "all 0.2s ease"
                }}
              >
                {tab === "customers" ? "Clientes (Leads)" : tab === "properties" ? "Imóveis" : "Jornadas"}
              </button>
            ))}
          </div>

          {/* Tab Contents */}
          <div style={{ display: "grid", gridTemplateColumns: "2fr 1fr", gap: "2rem", marginBottom: "3rem" }}>
            
            {/* Left Side: Table List */}
            <div className="card">
              {activeTab === "customers" && (
                <div>
                  <h3 style={{ marginBottom: "1.5rem" }}>👥 Clientes Cadastrados</h3>
                  {customers.length === 0 ? (
                    <p style={{ color: "var(--text-secondary)" }}>Nenhum cliente cadastrado neste tenant.</p>
                  ) : (
                    <div style={{ overflowX: "auto" }}>
                      <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
                        <thead>
                          <tr style={{ borderBottom: "1px solid var(--glass-border)", color: "var(--text-secondary)" }}>
                            <th style={{ padding: "0.75rem" }}>Nome</th>
                            <th style={{ padding: "0.75rem" }}>E-mail</th>
                            <th style={{ padding: "0.75rem" }}>Renda</th>
                            <th style={{ padding: "0.75rem" }}>Status</th>
                          </tr>
                        </thead>
                        <tbody>
                          {customers.map(c => (
                            <tr key={c.id} style={{ borderBottom: "1px solid var(--glass-border)" }}>
                              <td style={{ padding: "0.75rem", fontWeight: "600" }}>{c.name}</td>
                              <td style={{ padding: "0.75rem", color: "var(--text-secondary)" }}>{c.email || "N/A"}</td>
                              <td style={{ padding: "0.75rem" }}>R$ {c.monthlyIncome?.toLocaleString("pt-BR") || "0"}</td>
                              <td style={{ padding: "0.75rem" }}>
                                <span style={{
                                  background: "rgba(99, 102, 241, 0.15)",
                                  color: "var(--color-accent)",
                                  padding: "0.25rem 0.5rem",
                                  borderRadius: "4px",
                                  fontSize: "0.75rem"
                                }}>{c.status}</span>
                              </td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              )}

              {activeTab === "properties" && (
                <div>
                  <h3 style={{ marginBottom: "1.5rem" }}>🏢 Imóveis Disponíveis</h3>
                  {properties.length === 0 ? (
                    <p style={{ color: "var(--text-secondary)" }}>Nenhum imóvel cadastrado neste tenant.</p>
                  ) : (
                    <div style={{ overflowX: "auto" }}>
                      <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
                        <thead>
                          <tr style={{ borderBottom: "1px solid var(--glass-border)", color: "var(--text-secondary)" }}>
                            <th style={{ padding: "0.75rem" }}>Título</th>
                            <th style={{ padding: "0.75rem" }}>Cidade</th>
                            <th style={{ padding: "0.75rem" }}>Preço</th>
                            <th style={{ padding: "0.75rem" }}>Tipo</th>
                          </tr>
                        </thead>
                        <tbody>
                          {properties.map(p => (
                            <tr key={p.id} style={{ borderBottom: "1px solid var(--glass-border)" }}>
                              <td style={{ padding: "0.75rem", fontWeight: "600" }}>{p.title}</td>
                              <td style={{ padding: "0.75rem", color: "var(--text-secondary)" }}>{p.addressCity || "N/A"}</td>
                              <td style={{ padding: "0.75rem" }}>R$ {p.price?.toLocaleString("pt-BR")}</td>
                              <td style={{ padding: "0.75rem" }}>{p.type}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              )}

              {activeTab === "journeys" && (
                <div>
                  <h3 style={{ marginBottom: "1.5rem" }}>📍 Jornadas de Compra Ativas</h3>
                  {journeys.length === 0 ? (
                    <p style={{ color: "var(--text-secondary)" }}>Nenhuma jornada iniciada neste tenant.</p>
                  ) : (
                    <div style={{ overflowX: "auto" }}>
                      <table style={{ width: "100%", borderCollapse: "collapse", textAlign: "left" }}>
                        <thead>
                          <tr style={{ borderBottom: "1px solid var(--glass-border)", color: "var(--text-secondary)" }}>
                            <th style={{ padding: "0.75rem" }}>Cliente</th>
                            <th style={{ padding: "0.75rem" }}>Imóvel ID</th>
                            <th style={{ padding: "0.75rem" }}>Status</th>
                            <th style={{ padding: "0.75rem" }}>Ações</th>
                          </tr>
                        </thead>
                        <tbody>
                          {journeys.map(j => {
                            const clientName = customers.find(c => c.id === j.customerId)?.name || j.customerId.substring(0, 8);
                            return (
                              <tr 
                                key={j.id} 
                                style={{ 
                                  borderBottom: "1px solid var(--glass-border)",
                                  background: selectedJourney?.id === j.id ? "rgba(99, 102, 241, 0.05)" : "transparent",
                                  cursor: "pointer"
                                }}
                                onClick={() => setSelectedJourney(j)}
                              >
                                <td style={{ padding: "0.75rem", fontWeight: "600" }}>{clientName}</td>
                                <td style={{ padding: "0.75rem", color: "var(--text-secondary)" }}>{j.propertyId ? j.propertyId.substring(0, 8) : "Nenhum"}</td>
                                <td style={{ padding: "0.75rem" }}>
                                  <span style={{
                                    background: j.status === "COMPLETED" ? "rgba(16, 185, 129, 0.15)" : "rgba(245, 158, 11, 0.15)",
                                    color: j.status === "COMPLETED" ? "var(--color-success)" : "var(--color-warning)",
                                    padding: "0.25rem 0.5rem",
                                    borderRadius: "4px",
                                    fontSize: "0.75rem",
                                    fontWeight: "bold"
                                  }}>{j.status}</span>
                                </td>
                                <td style={{ padding: "0.75rem" }}>
                                  <div style={{ display: "flex", gap: "0.5rem" }} onClick={e => e.stopPropagation()}>
                                    <button 
                                      className="btn btn-secondary" 
                                      style={{ padding: "0.25rem 0.5rem", fontSize: "0.75rem" }}
                                      onClick={() => handleUpdateJourneyStatus(j.id, "FINANCING_APPROVED")}
                                    >
                                      Aprovar
                                    </button>
                                    <button 
                                      className="btn btn-primary" 
                                      style={{ padding: "0.25rem 0.5rem", fontSize: "0.75rem" }}
                                      onClick={() => handleUpdateJourneyStatus(j.id, "COMPLETED")}
                                    >
                                      Finalizar
                                    </button>
                                  </div>
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Right Side: Action Forms */}
            <div className="card">
              {activeTab === "customers" && (
                <form onSubmit={handleCreateCustomer}>
                  <h3 style={{ marginBottom: "1.25rem" }}>➕ Cadastrar Cliente</h3>
                  <div className="input-group">
                    <label className="label">Nome Completo</label>
                    <input 
                      type="text" 
                      className="input" 
                      value={customerForm.name}
                      onChange={e => setCustomerForm({ ...customerForm, name: e.target.value })}
                      required
                    />
                  </div>
                  <div className="input-group">
                    <label className="label">E-mail</label>
                    <input 
                      type="email" 
                      className="input" 
                      value={customerForm.email}
                      onChange={e => setCustomerForm({ ...customerForm, email: e.target.value })}
                      required
                    />
                  </div>
                  <div className="input-group">
                    <label className="label">Renda Mensal</label>
                    <input 
                      type="number" 
                      className="input" 
                      value={customerForm.monthlyIncome}
                      onChange={e => setCustomerForm({ ...customerForm, monthlyIncome: Number(e.target.value) })}
                      required
                    />
                  </div>
                  <button type="submit" className="btn btn-primary" style={{ width: "100%" }}>Criar Cliente</button>
                </form>
              )}

              {activeTab === "properties" && (
                <form onSubmit={handleCreateProperty}>
                  <h3 style={{ marginBottom: "1.25rem" }}>➕ Cadastrar Imóvel</h3>
                  <div className="input-group">
                    <label className="label">Título do Imóvel</label>
                    <input 
                      type="text" 
                      className="input" 
                      value={propertyForm.title}
                      onChange={e => setPropertyForm({ ...propertyForm, title: e.target.value })}
                      required
                    />
                  </div>
                  <div className="input-group">
                    <label className="label">Preço de Venda</label>
                    <input 
                      type="number" 
                      className="input" 
                      value={propertyForm.price}
                      onChange={e => setPropertyForm({ ...propertyForm, price: Number(e.target.value) })}
                      required
                    />
                  </div>
                  <div className="input-group">
                    <label className="label">Cidade</label>
                    <input 
                      type="text" 
                      className="input" 
                      value={propertyForm.addressCity}
                      onChange={e => setPropertyForm({ ...propertyForm, addressCity: e.target.value })}
                      required
                    />
                  </div>
                  <button type="submit" className="btn btn-primary" style={{ width: "100%" }}>Cadastrar Imóvel</button>
                </form>
              )}

              {activeTab === "journeys" && (
                <form onSubmit={handleCreateJourney}>
                  <h3 style={{ marginBottom: "1.25rem" }}>➕ Iniciar Jornada</h3>
                  
                  <div className="input-group">
                    <label className="label">Cliente Comprador</label>
                    <select 
                      className="input"
                      value={journeyForm.customerId}
                      onChange={e => setJourneyForm({ ...journeyForm, customerId: e.target.value })}
                      required
                    >
                      <option value="">Selecione um cliente...</option>
                      {customers.map(c => (
                        <option key={c.id} value={c.id}>{c.name}</option>
                      ))}
                    </select>
                  </div>

                  <div className="input-group">
                    <label className="label">Imóvel Escolhido</label>
                    <select 
                      className="input"
                      value={journeyForm.propertyId}
                      onChange={e => setJourneyForm({ ...journeyForm, propertyId: e.target.value })}
                    >
                      <option value="">Selecione um imóvel...</option>
                      {properties.map(p => (
                        <option key={p.id} value={p.id}>{p.title} - R$ {p.price.toLocaleString("pt-BR")}</option>
                      ))}
                    </select>
                  </div>

                  <button type="submit" className="btn btn-primary" style={{ width: "100%" }}>Iniciar Fluxo</button>
                </form>
              )}
            </div>
          </div>
        </>
      ) : (
        /* Client Portal welcome banner */
        <div className="card animate-fade-in" style={{ padding: "2.5rem", marginBottom: "2.5rem", background: "linear-gradient(135deg, rgba(99, 102, 241, 0.08), rgba(6, 182, 212, 0.08))", borderColor: "rgba(99, 102, 241, 0.3)" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "1.5rem" }}>
            <div>
              <h2 style={{ fontSize: "2rem", color: "white", marginBottom: "0.5rem", fontFamily: "var(--font-title)" }}>Olá, Felipe Lima! 👋</h2>
              <p style={{ color: "var(--text-secondary)", fontSize: "1.05rem" }}>
                Seja bem-vindo ao seu portal de intermediação na <strong>WFJ Imóveis</strong>.
              </p>
              <p style={{ color: "var(--text-muted)", fontSize: "0.9rem", marginTop: "0.5rem" }}>
                Acompanhe o andamento da sua compra, envie os documentos para o cartório de notas e realize a quitação de forma segura.
              </p>
            </div>
            <div style={{
              background: "rgba(255,255,255,0.02)",
              border: "1px solid var(--glass-border)",
              borderRadius: "var(--radius-md)",
              padding: "1rem",
              textAlign: "center"
            }}>
              <span className="label" style={{ fontSize: "0.75rem" }}>Imóvel em Jardim Romano</span>
              <div style={{ fontSize: "1.2rem", fontWeight: "bold", color: "white", marginTop: "0.25rem" }}>Casa Padrão</div>
              <div style={{ color: "var(--color-secondary)", fontWeight: "bold", fontSize: "1.1rem" }}>R$ 250.000,00</div>
            </div>
          </div>
        </div>
      )}

      {/* Selected Journey Detail Dashboard */}
      {selectedJourney && (
        <section className="card animate-fade-in" style={{ padding: "2.5rem", marginTop: "3rem" }}>
          {/* Header of selected journey */}
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "2rem", borderBottom: "1px solid var(--glass-border)", paddingBottom: "1.5rem", flexWrap: "wrap", gap: "1rem" }}>
            <div>
              <span className="label" style={{ color: "var(--color-accent)", fontSize: "0.8rem", fontWeight: "bold" }}>
                Jornada de Compra Ativa
              </span>
              <h3 style={{ fontSize: "1.8rem", marginTop: "0.25rem" }}>
                🏠 {customers.find(c => c.id === selectedJourney.customerId)?.name || "Cliente"}
              </h3>
              <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginTop: "0.25rem" }}>
                Imóvel ID: <code style={{ color: "white" }}>{selectedJourney.propertyId || "Não especificado"}</code> | Corretor: {tenant === "00000000-0000-0000-0000-000000000003" ? "WFJ Corretor" : "Corretor Interno"}
              </p>
            </div>
            <div style={{ display: "flex", gap: "0.75rem", alignItems: "center" }}>
              <select 
                value={selectedJourney.status}
                onChange={(e) => handleUpdateJourneyStatus(selectedJourney.id, e.target.value)}
                style={{
                  background: "var(--bg-secondary)",
                  border: "1px solid var(--glass-border)",
                  color: "white",
                  padding: "0.5rem",
                  borderRadius: "var(--radius-sm)",
                  cursor: "pointer",
                  fontSize: "0.85rem"
                }}
              >
                <option value="STARTED">STARTED (Iniciada)</option>
                <option value="ANALYSIS">ANALYSIS (Análise de Crédito)</option>
                <option value="FINANCING_APPROVED">FINANCING_APPROVED (Aprovado)</option>
                <option value="CONTRACT_SIGNED">CONTRACT_SIGNED (Contrato Assinado)</option>
                <option value="COMPLETED">COMPLETED (Concluída)</option>
              </select>
              <span style={{
                background: selectedJourney.status === "COMPLETED" ? "rgba(16, 185, 129, 0.15)" : "rgba(245, 158, 11, 0.15)",
                border: selectedJourney.status === "COMPLETED" ? "1px solid var(--color-success)" : "1px solid var(--color-warning)",
                color: selectedJourney.status === "COMPLETED" ? "var(--color-success)" : "var(--color-warning)",
                padding: "0.5rem 1rem",
                borderRadius: "var(--radius-full)",
                fontSize: "0.85rem",
                fontWeight: "bold"
              }}>
                {selectedJourney.status}
              </span>
            </div>
          </div>

          {loadingDetails ? (
            <div style={{ padding: "4rem", textAlign: "center", color: "var(--text-secondary)" }}>
              <div className="animate-pulse">Buscando dados da jornada no banco de dados...</div>
            </div>
          ) : (
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "2.5rem", alignItems: "start" }}>
              
              {/* Left Column: Real Timeline of Events */}
              <div>
                <h4 style={{ fontSize: "1.2rem", marginBottom: "1.5rem", color: "white", display: "flex", alignItems: "center", gap: "0.5rem" }}>
                  📍 Histórico de Atividades
                </h4>

                {timelineEvents.length === 0 ? (
                  <div style={{ padding: "2.5rem", background: "rgba(255,255,255,0.01)", border: "1px dashed var(--glass-border)", borderRadius: "var(--radius-md)", textAlign: "center", color: "var(--text-muted)" }}>
                    Nenhuma atividade registrada na timeline para esta jornada.
                  </div>
                ) : (
                  <div style={{ display: "flex", flexDirection: "column", gap: "1.5rem", position: "relative", paddingLeft: "1.5rem", borderLeft: "2px dashed var(--glass-border)" }}>
                    {timelineEvents.map((event) => {
                      let parsedMetadata: any = {};
                      if (event.metadata) {
                        try {
                          parsedMetadata = typeof event.metadata === "string" ? JSON.parse(event.metadata) : event.metadata;
                        } catch (e) {
                          console.error("Error parsing metadata", e);
                        }
                      }

                      return (
                        <div key={event.id} style={{ position: "relative" }}>
                          {/* Circle marker */}
                          <div style={{
                            position: "absolute",
                            left: "-31px",
                            top: "4px",
                            width: "12px",
                            height: "12px",
                            borderRadius: "50%",
                            background: event.type === "CHECKLIST_UPDATED" ? "var(--color-secondary)" : event.type === "CONTRACT_SIGNED" ? "var(--color-success)" : "var(--color-accent)",
                            boxShadow: `0 0 10px ${event.type === "CHECKLIST_UPDATED" ? "var(--color-secondary)" : event.type === "CONTRACT_SIGNED" ? "var(--color-success)" : "var(--color-accent)"}`,
                            border: "2px solid var(--bg-primary)"
                          }} />
                          
                          <div className="card" style={{ background: "rgba(255,255,255,0.02)", padding: "1.25rem", border: "1px solid rgba(255,255,255,0.04)" }}>
                            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start", marginBottom: "0.5rem" }}>
                              <h5 style={{ fontSize: "1rem", color: "white", fontWeight: "600" }}>{event.title}</h5>
                              <span style={{ fontSize: "0.75rem", color: "var(--text-muted)" }}>
                                {new Date(event.createdAt).toLocaleDateString("pt-BR")} {new Date(event.createdAt).toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" })}
                              </span>
                            </div>
                            <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)" }}>{event.description}</p>
                            
                            {/* Special content based on type */}
                            {event.type === "DUE_DILIGENCE" && parsedMetadata.risk_score && (
                              <div style={{ marginTop: "0.75rem", padding: "0.75rem", background: "rgba(16, 185, 129, 0.05)", borderRadius: "var(--radius-sm)", border: "1px solid rgba(16, 185, 129, 0.15)", fontSize: "0.8rem" }}>
                                <div style={{ display: "flex", gap: "0.75rem", flexWrap: "wrap", justifyContent: "space-between" }}>
                                  <span>🟢 Análise: <strong style={{ color: "var(--color-success)" }}>{parsedMetadata.risk_score}</strong></span>
                                  <span>Matrícula: <strong>{parsedMetadata.matricula_status}</strong></span>
                                  <span>IPTU: <strong>{parsedMetadata.iptu_status}</strong></span>
                                  <span>Certidões: <strong>{parsedMetadata.seller_certidoes}</strong></span>
                                </div>
                              </div>
                            )}

                            {(event.type === "PROPOSAL_SENT" || event.type === "PROPOSAL_ACCEPTED") && parsedMetadata.offer_amount && (
                              <div style={{ marginTop: "0.75rem", display: "flex", gap: "0.5rem", flexWrap: "wrap" }}>
                                <span style={{ background: "rgba(99, 102, 241, 0.15)", color: "var(--color-accent)", padding: "0.2rem 0.5rem", borderRadius: "4px", fontSize: "0.75rem", fontWeight: "bold" }}>
                                  Valor: R$ {parsedMetadata.offer_amount.toLocaleString("pt-BR")}
                                </span>
                                <span style={{ background: "rgba(255,255,255,0.05)", padding: "0.2rem 0.5rem", borderRadius: "4px", fontSize: "0.75rem", color: "white" }}>
                                  Método: {parsedMetadata.payment_method === "CASH_FULL" ? "À Vista" : parsedMetadata.payment_method}
                                </span>
                              </div>
                            )}

                            {event.type === "CONTRACT_SIGNED" && parsedMetadata.signature_method && (
                              <div style={{ marginTop: "0.5rem", fontSize: "0.75rem", color: "var(--text-muted)" }}>
                                Assinado via: <strong>{parsedMetadata.signature_method}</strong> | Hash: <code>{parsedMetadata.audit_trail_id}</code>
                              </div>
                            )}
                          </div>
                        </div>
                      );
                    })}
                  </div>
                )}
              </div>

              {/* Right Column: Intermediation, Checklist and Costs */}
              <div style={{ display: "flex", flexDirection: "column", gap: "2rem" }}>
                
                {/* 📋 Next Steps Checklist */}
                {(() => {
                  const checklistEvent = timelineEvents.find(e => e.type === "CHECKLIST_UPDATED");
                  if (!checklistEvent) {
                    return (
                      <div className="card" style={{ textAlign: "center", padding: "2.5rem", color: "var(--text-muted)" }}>
                        <h4 style={{ color: "white", marginBottom: "0.5rem" }}>📋 Fluxo de Intermediação</h4>
                        O checklist interativo de quitação, ITBI, escritura e cartório estará disponível assim que a proposta for aceita e o contrato for assinado.
                      </div>
                    );
                  }

                  let nextSteps: any[] = [];
                  let totalClosingCosts = 0;
                  let docs: any = {};
                  try {
                    const meta = typeof checklistEvent.metadata === "string" ? JSON.parse(checklistEvent.metadata) : checklistEvent.metadata;
                    nextSteps = meta.next_steps || [];
                    totalClosingCosts = meta.total_closing_costs || 0;
                    docs = {
                      buyer: meta.documents_required_buyer || [],
                      seller: meta.documents_required_seller || [],
                      property: meta.documents_required_property || []
                    };
                  } catch (e) {
                    console.error(e);
                  }

                  return (
                    <>
                      <div>
                        <h4 style={{ fontSize: "1.2rem", marginBottom: "1rem", color: "white", display: "flex", alignItems: "center", gap: "0.5rem" }}>
                          📋 Checklist de Quitação & Cartórios
                        </h4>
                        <div style={{ display: "flex", flexDirection: "column", gap: "0.75rem" }}>
                          {nextSteps.map((step) => {
                            const isChecked = completedLocalSteps.includes(step.step);
                            const showDiscountBtn = (step.step === 1 || step.step === 2 || step.step === 4) && userRole === "client";
                            return (
                              <div key={step.step} className="card" style={{
                                background: isChecked ? "rgba(16, 185, 129, 0.02)" : "rgba(255,255,255,0.01)",
                                borderColor: isChecked ? "rgba(16, 185, 129, 0.3)" : "var(--glass-border)",
                                padding: "1rem",
                                display: "flex",
                                gap: "0.75rem",
                                alignItems: "flex-start",
                                cursor: "pointer"
                              }} onClick={() => toggleLocalStep(step.step)}>
                                <input 
                                  type="checkbox" 
                                  checked={isChecked}
                                  onChange={() => {}}
                                  style={{
                                    marginTop: "0.25rem",
                                    width: "18px",
                                    height: "18px",
                                    accentColor: "var(--color-success)",
                                    cursor: "pointer"
                                  }}
                                />
                                <div style={{ flex: 1 }}>
                                  <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "0.5rem" }}>
                                    <strong style={{ fontSize: "0.95rem", color: isChecked ? "var(--text-muted)" : "white", textDecoration: isChecked ? "line-through" : "none" }}>
                                      Passo {step.step}: {step.title}
                                    </strong>
                                    {step.estimated_cost > 0 && (
                                      <span style={{ fontSize: "0.75rem", background: "rgba(255, 255, 255, 0.05)", padding: "0.2rem 0.4rem", borderRadius: "4px", color: discountResult && (step.step === 2 || step.step === 4) ? "var(--color-success)" : "var(--text-secondary)", textDecoration: discountResult && (step.step === 2 || step.step === 4) ? "line-through" : "none" }}>
                                        R$ {step.estimated_cost.toLocaleString("pt-BR")}
                                      </span>
                                    )}
                                    {discountResult && step.step === 2 && (
                                      <span style={{ fontSize: "0.75rem", background: "rgba(16, 185, 129, 0.15)", padding: "0.2rem 0.5rem", borderRadius: "4px", color: "var(--color-success)", fontWeight: "bold" }}>
                                        R$ {discountResult.discountedEscritura.toLocaleString("pt-BR")} (-50%)
                                      </span>
                                    )}
                                    {discountResult && step.step === 4 && (
                                      <span style={{ fontSize: "0.75rem", background: "rgba(16, 185, 129, 0.15)", padding: "0.2rem 0.5rem", borderRadius: "4px", color: "var(--color-success)", fontWeight: "bold" }}>
                                        R$ {discountResult.discountedRegistro.toLocaleString("pt-BR")} (-50%)
                                      </span>
                                    )}
                                  </div>
                                  <p style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginTop: "0.25rem" }}>
                                    {step.description}
                                  </p>
                                  {step.deadline && (
                                    <div style={{ fontSize: "0.75rem", color: "var(--text-muted)", marginTop: "0.25rem" }}>
                                      Prazo sugerido: {new Date(step.deadline).toLocaleDateString("pt-BR")}
                                    </div>
                                  )}
                                  {showDiscountBtn && !discountResult && (
                                    <button
                                      className="btn btn-primary"
                                      style={{ marginTop: "0.5rem", padding: "0.3rem 0.75rem", fontSize: "0.75rem", background: "linear-gradient(135deg, #6366f1, #06b6d4)" }}
                                      onClick={(e) => { e.stopPropagation(); handleDiscountAnalysis(); }}
                                    >
                                      🔍 Verificar Isenção / Desconto 1º Imóvel
                                    </button>
                                  )}
                                  {discountResult && step.step === 1 && (
                                    <div style={{ marginTop: "0.5rem", padding: "0.4rem 0.6rem", borderRadius: "6px", background: "rgba(239, 68, 68, 0.08)", border: "1px solid rgba(239, 68, 68, 0.2)", fontSize: "0.75rem", color: "#fca5a5" }}>
                                      ❌ ITBI sem isenção — {discountResult.itbiReason}
                                    </div>
                                  )}
                                  {discountResult && (step.step === 2 || step.step === 4) && (
                                    <div style={{ marginTop: "0.5rem", padding: "0.4rem 0.6rem", borderRadius: "6px", background: "rgba(16, 185, 129, 0.08)", border: "1px solid rgba(16, 185, 129, 0.2)", fontSize: "0.75rem", color: "#6ee7b7" }}>
                                      ✅ Desconto de 50% aplicável — {discountResult.firstPropertyLaw}
                                      <button onClick={(e) => { e.stopPropagation(); setShowDiscountModal(true); }} style={{ marginLeft: "0.5rem", background: "none", border: "none", color: "var(--color-accent)", cursor: "pointer", fontSize: "0.75rem", textDecoration: "underline" }}>Ver detalhes</button>
                                    </div>
                                  )}
                                </div>
                              </div>
                            );
                          })}
                        </div>
                      </div>

                      {/* 💰 Costs Box */}
                      {totalClosingCosts > 0 && (
                        <div className="card" style={{
                          background: "linear-gradient(135deg, rgba(99, 102, 241, 0.04), rgba(6, 182, 212, 0.04))",
                          borderColor: "rgba(99, 102, 241, 0.3)",
                          padding: "1.25rem",
                        }}>
                          <h4 style={{ fontSize: "1.1rem", marginBottom: "0.75rem", color: "white" }}>
                            💰 Despesas de Fechamento Estimadas
                          </h4>
                          <div style={{ display: "flex", flexDirection: "column", gap: "0.5rem", fontSize: "0.85rem" }}>
                            {nextSteps.filter(s => s.estimated_cost > 0).map(s => (
                              <div key={s.step} style={{ display: "flex", justifyContent: "space-between", color: "var(--text-secondary)" }}>
                                <span>{s.title}</span>
                                <span>R$ {s.estimated_cost.toLocaleString("pt-BR")}</span>
                              </div>
                            ))}
                            <hr style={{ border: "none", borderTop: "1px solid var(--glass-border)", margin: "0.5rem 0" }} />
                            <div style={{ display: "flex", justifyContent: "space-between", fontSize: "1rem", fontWeight: "bold", color: "white" }}>
                              <span>Custos Extras Estimados:</span>
                              <span style={{ color: "var(--color-secondary)" }}>R$ {totalClosingCosts.toLocaleString("pt-BR")}</span>
                            </div>
                            <p style={{ fontSize: "0.75rem", color: "var(--text-muted)", marginTop: "0.5rem", fontStyle: "italic" }}>
                              * Valores oficiais para a comarca de São Paulo.
                            </p>
                          </div>
                        </div>
                      )}

                      {/* 📂 Gerenciador de Documentos */}
                      <div className="card" style={{ padding: "1.5rem" }}>
                        <h4 style={{ fontSize: "1.1rem", marginBottom: "0.75rem", color: "white", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
                          <span>📂 Documentação para Transferência (Escritura)</span>
                          {uploadingFile && <span style={{ fontSize: "0.75rem", color: "var(--color-secondary)" }} className="animate-pulse">Enviando...</span>}
                        </h4>
                        <p style={{ fontSize: "0.8rem", color: "var(--text-secondary)", marginBottom: "1rem" }}>
                          Envie os arquivos necessários para a lavratura da escritura pública no Cartório de Notas.
                        </p>

                        <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
                          {[
                            { label: "Contrato de Compra e Venda Assinado", type: "CONTRATO_COMPRA_VENDA" },
                            { label: "RG e CPF do Comprador", type: "RG_CPF_COMPRADOR" },
                            { label: "Comprovante de Estado Civil", type: "ESTADO_CIVIL_COMPRADOR" }
                          ].map(docType => {
                            const isUploaded = uploadedDocuments.find(d => d.type === docType.type);
                            return (
                              <div key={docType.type} style={{
                                display: "flex",
                                justifyContent: "space-between",
                                alignItems: "center",
                                padding: "0.75rem 1rem",
                                background: "rgba(255,255,255,0.02)",
                                borderRadius: "var(--radius-sm)",
                                border: "1px solid var(--glass-border)",
                              }}>
                                <div>
                                  <div style={{ fontSize: "0.9rem", fontWeight: "600", color: isUploaded ? "var(--text-muted)" : "white" }}>
                                    {isUploaded ? "✓ " : ""}{docType.label}
                                  </div>
                                  {isUploaded ? (
                                    <span style={{ fontSize: "0.75rem", color: "var(--color-success)", fontWeight: "bold" }}>
                                      🟢 Enviado em {new Date(isUploaded.createdAt).toLocaleDateString("pt-BR")}
                                    </span>
                                  ) : (
                                    <span style={{ fontSize: "0.75rem", color: "var(--color-warning)" }}>
                                      ⚠️ Pendente
                                    </span>
                                  )}
                                </div>
                                
                                {isUploaded ? (
                                  <button 
                                    className="btn btn-secondary" 
                                    style={{ padding: "0.25rem 0.5rem", fontSize: "0.75rem" }}
                                    onClick={() => window.open(api.documents.getDownloadUrl(isUploaded.id), "_blank")}
                                  >
                                    Visualizar
                                  </button>
                                ) : (
                                  <label className="btn btn-primary" style={{ padding: "0.25rem 0.5rem", fontSize: "0.75rem", cursor: "pointer", margin: 0 }}>
                                    Enviar
                                    <input 
                                      type="file" 
                                      accept=".pdf,.png,.jpg,.jpeg"
                                      style={{ display: "none" }}
                                      onChange={(e) => handleUploadDocument(e, docType.label, docType.type)}
                                    />
                                  </label>
                                )}
                              </div>
                            );
                          })}
                        </div>

                        {uploadedDocuments.length > 0 && (
                          <div style={{ marginTop: "1rem", borderTop: "1px solid var(--glass-border)", paddingTop: "1rem" }}>
                            <h5 style={{ fontSize: "0.85rem", color: "var(--text-secondary)", marginBottom: "0.5rem" }}>
                              Arquivos Recebidos pelo Cartório:
                            </h5>
                            <ul style={{ listStyleType: "none", padding: 0, margin: 0, fontSize: "0.8rem", color: "white" }}>
                              {uploadedDocuments.map(doc => (
                                <li key={doc.id} style={{ display: "flex", justifyContent: "space-between", padding: "0.25rem 0" }}>
                                  <span style={{ textOverflow: "ellipsis", overflow: "hidden", whiteSpace: "nowrap", maxWidth: "250px" }}>
                                    📄 {doc.title}
                                  </span>
                                  <span style={{ color: "var(--text-muted)" }}>
                                    ({(doc.fileSize / 1024).toFixed(1)} KB)
                                  </span>
                                </li>
                              ))}
                            </ul>
                          </div>
                        )}
                      </div>
                    </>
                  );
                })()}

              </div>
              
            </div>
          )}
        </section>
      )}
      {/* Discount Analysis Modal */}
      {showDiscountModal && (
        <div style={{ position: "fixed", top: 0, left: 0, right: 0, bottom: 0, background: "rgba(0,0,0,0.7)", backdropFilter: "blur(8px)", zIndex: 9999, display: "flex", alignItems: "center", justifyContent: "center", padding: "1rem" }} onClick={() => setShowDiscountModal(false)}>
          <div className="card animate-fade-in" style={{ maxWidth: "600px", width: "100%", maxHeight: "85vh", overflowY: "auto", padding: "2rem" }} onClick={(e) => e.stopPropagation()}>
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "1.5rem" }}>
              <h3 style={{ color: "white", fontSize: "1.3rem" }}>🔍 Análise de Isenção e Descontos</h3>
              <button onClick={() => setShowDiscountModal(false)} style={{ background: "none", border: "none", color: "var(--text-muted)", fontSize: "1.5rem", cursor: "pointer" }}>✕</button>
            </div>

            {discountAnalyzing ? (
              <div style={{ textAlign: "center", padding: "3rem 0" }}>
                <div className="animate-pulse" style={{ fontSize: "2rem", marginBottom: "1rem" }}>🤖</div>
                <p style={{ color: "var(--color-secondary)", fontWeight: "bold" }}>Analisando legislação aplicável...</p>
                <p style={{ color: "var(--text-muted)", fontSize: "0.85rem", marginTop: "0.5rem" }}>Cruzando dados do contrato com a legislação municipal de SP, Lei de Registros Públicos e normativas do SFH...</p>
              </div>
            ) : discountResult && (
              <div style={{ display: "flex", flexDirection: "column", gap: "1.25rem" }}>
                {/* ITBI Result */}
                <div style={{ padding: "1rem", borderRadius: "8px", background: "rgba(239, 68, 68, 0.06)", border: "1px solid rgba(239, 68, 68, 0.2)" }}>
                  <h4 style={{ color: "#fca5a5", fontSize: "0.95rem", marginBottom: "0.5rem" }}>❌ ITBI — Sem Isenção</h4>
                  <p style={{ color: "var(--text-secondary)", fontSize: "0.85rem" }}>{discountResult.itbiReason}</p>
                  <p style={{ color: "var(--text-muted)", fontSize: "0.75rem", marginTop: "0.25rem" }}>Valor mantido: <strong style={{ color: "white" }}>R$ 7.500,00</strong> (3% de R$ 250.000)</p>
                </div>

                {/* First Property Discount */}
                <div style={{ padding: "1rem", borderRadius: "8px", background: "rgba(16, 185, 129, 0.06)", border: "1px solid rgba(16, 185, 129, 0.25)" }}>
                  <h4 style={{ color: "#6ee7b7", fontSize: "0.95rem", marginBottom: "0.5rem" }}>✅ Desconto 1º Imóvel — 50% em Escritura e Registro</h4>
                  <div style={{ display: "flex", flexDirection: "column", gap: "0.4rem", fontSize: "0.85rem", color: "var(--text-secondary)" }}>
                    <div style={{ display: "flex", justifyContent: "space-between" }}>
                      <span>Escritura Pública:</span>
                      <span><s style={{ color: "var(--text-muted)" }}>R$ {discountResult.originalEscritura.toLocaleString("pt-BR")}</s> → <strong style={{ color: "var(--color-success)" }}>R$ {discountResult.discountedEscritura.toLocaleString("pt-BR")}</strong></span>
                    </div>
                    <div style={{ display: "flex", justifyContent: "space-between" }}>
                      <span>Registro no CRI:</span>
                      <span><s style={{ color: "var(--text-muted)" }}>R$ {discountResult.originalRegistro.toLocaleString("pt-BR")}</s> → <strong style={{ color: "var(--color-success)" }}>R$ {discountResult.discountedRegistro.toLocaleString("pt-BR")}</strong></span>
                    </div>
                  </div>
                </div>

                {/* Savings */}
                <div style={{ padding: "1rem", borderRadius: "8px", background: "linear-gradient(135deg, rgba(99,102,241,0.08), rgba(6,182,212,0.08))", border: "1px solid rgba(99,102,241,0.3)", textAlign: "center" }}>
                  <p style={{ color: "var(--text-secondary)", fontSize: "0.85rem" }}>Economia Total Identificada</p>
                  <p style={{ color: "var(--color-secondary)", fontSize: "1.8rem", fontWeight: "bold" }}>R$ {discountResult.savings.toLocaleString("pt-BR")}</p>
                  <p style={{ color: "var(--text-secondary)", fontSize: "0.85rem", marginTop: "0.25rem" }}>
                    Novo total de custos: <s style={{ color: "var(--text-muted)" }}>R$ {discountResult.originalTotal.toLocaleString("pt-BR")}</s> → <strong style={{ color: "white" }}>R$ {discountResult.newTotal.toLocaleString("pt-BR")}</strong>
                  </p>
                </div>

                {/* Legal Basis */}
                <div>
                  <h4 style={{ color: "white", fontSize: "0.9rem", marginBottom: "0.5rem" }}>📚 Base Legal</h4>
                  {discountResult.legalBasis.map((l: any, i: number) => (
                    <div key={i} style={{ padding: "0.5rem", borderBottom: "1px solid var(--glass-border)", fontSize: "0.8rem" }}>
                      <strong style={{ color: "var(--color-accent)" }}>{l.law}</strong>
                      <p style={{ color: "var(--text-secondary)", margin: "0.15rem 0 0" }}>{l.desc}</p>
                    </div>
                  ))}
                </div>

                {/* Requirements */}
                <div>
                  <h4 style={{ color: "white", fontSize: "0.9rem", marginBottom: "0.5rem" }}>📋 Documentos Necessários para Solicitar</h4>
                  <ul style={{ padding: "0 0 0 1.25rem", margin: 0, color: "var(--text-secondary)", fontSize: "0.8rem" }}>
                    {discountResult.requirements.map((r: string, i: number) => (
                      <li key={i} style={{ marginBottom: "0.25rem" }}>{r}</li>
                    ))}
                  </ul>
                </div>

                <button className="btn btn-primary" style={{ marginTop: "0.5rem", background: "linear-gradient(135deg, #10b981, #06b6d4)" }} onClick={() => { setShowDiscountModal(false); showToast("Desconto de 1º imóvel aplicado ao seu checklist!"); }}>
                  ✅ Aplicar Desconto ao Meu Checklist
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
