const BASE_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080/api/v1";

function getHeaders(): HeadersInit {
  const headers: HeadersInit = {
    "Content-Type": "application/json",
  };
  
  if (typeof window !== "undefined") {
    const tenantId = localStorage.getItem("imobflow_tenant_id");
    if (tenantId) {
      headers["X-Tenant-ID"] = tenantId;
    } else {
      // Default fallback tenant ID
      headers["X-Tenant-ID"] = "00000000-0000-0000-0000-000000000001";
    }
  }
  return headers;
}

export async function apiFetch<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  const url = `${BASE_URL}${endpoint}`;
  const response = await fetch(url, {
    ...options,
    headers: {
      ...getHeaders(),
      ...options.headers,
    },
  });

  if (!response.ok) {
    let errorMsg = "API request failed";
    try {
      const errorData = await response.json();
      errorMsg = errorData.message || errorMsg;
    } catch {
      // Ignore JSON parse error
    }
    throw new Error(errorMsg);
  }

  if (response.status === 204) {
    return {} as T;
  }

  return response.json() as Promise<T>;
}

export interface Customer {
  id: string;
  tenantId: string;
  name: string;
  email?: string;
  phone?: string;
  cpf?: string;
  rg?: string;
  status: string;
  monthlyIncome?: number;
  fgtsBalance?: number;
}

export interface Property {
  id: string;
  tenantId: string;
  title: string;
  type: string;
  status: string;
  price: number;
  addressCity?: string;
  bedrooms?: number;
}

export interface TimelineEvent {
  id: string;
  tenantId: string;
  journeyId: string;
  type: string;
  title: string;
  description?: string;
  metadata?: string; // JSON string
  createdBy?: string;
  createdAt: string;
}

export interface Proposal {
  id: string;
  tenantId: string;
  journeyId: string;
  propertyId: string;
  customerId: string;
  offerAmount: number;
  conditions?: string; // JSON string
  status: string;
  validUntil?: string;
  createdBy?: string;
  createdAt: string;
  updatedAt: string;
}

export interface DocumentFile {
  id: string;
  tenantId: string;
  journeyId: string;
  title: string;
  type: string;
  filePath: string;
  fileSize: number;
  status: string;
  uploadedBy?: string;
  createdAt: string;
  updatedAt: string;
}

export interface Journey {
  id: string;
  tenantId: string;
  customerId: string;
  propertyId?: string;
  brokerId: string;
  status: string;
  startedAt: string;
  closedAt?: string;
}

export const api = {
  customers: {
    list: (brokerId?: string) => 
      apiFetch<{ content: Customer[] }>(`/customers${brokerId ? `?brokerId=${brokerId}` : ""}`),
    create: (data: Partial<Customer>) => 
      apiFetch<Customer>("/customers", {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
  properties: {
    list: (filters: { type?: string; minPrice?: number; maxPrice?: number; city?: string } = {}) => {
      const params = new URLSearchParams();
      if (filters.type) params.append("type", filters.type);
      if (filters.minPrice) params.append("minPrice", filters.minPrice.toString());
      if (filters.maxPrice) params.append("maxPrice", filters.maxPrice.toString());
      if (filters.city) params.append("city", filters.city);
      return apiFetch<{ content: Property[] }>(`/properties?${params.toString()}`);
    },
    create: (data: Partial<Property>) =>
      apiFetch<Property>("/properties", {
        method: "POST",
        body: JSON.stringify(data),
      }),
  },
  journeys: {
    list: (brokerId: string) =>
      apiFetch<{ content: Journey[] }>(`/journeys?brokerId=${brokerId}`),
    create: (data: { customerId: string; propertyId?: string; brokerId: string }) =>
      apiFetch<Journey>("/journeys", {
        method: "POST",
        body: JSON.stringify(data),
      }),
    updateStatus: (id: string, status: string) =>
      apiFetch<Journey>(`/journeys/${id}/status?status=${status}`, {
        method: "PATCH",
      }),
    getTimeline: (id: string) =>
      apiFetch<TimelineEvent[]>(`/journeys/${id}/timeline`),
    getProposals: (id: string) =>
      apiFetch<Proposal[]>(`/journeys/${id}/proposals`),
  },
  documents: {
    list: (journeyId: string) =>
      apiFetch<DocumentFile[]>(`/documents/journey/${journeyId}`),
    upload: (journeyId: string, title: string, type: string, file: File) => {
      const formData = new FormData();
      formData.append("journeyId", journeyId);
      formData.append("title", title);
      formData.append("type", type);
      formData.append("file", file);
      
      const tenantId = typeof window !== "undefined" ? localStorage.getItem("imobflow_tenant_id") : null;
      const headers: HeadersInit = {};
      if (tenantId) {
        headers["X-Tenant-ID"] = tenantId;
      }
      
      return fetch(`http://localhost:8080/api/v1/documents/upload`, {
        method: "POST",
        headers,
        body: formData
      }).then(res => {
        if (!res.ok) throw new Error("Upload failed");
        return res.json() as Promise<DocumentFile>;
      });
    },
    getDownloadUrl: (documentId: string) => {
      return `${BASE_URL}/documents/${documentId}/download`;
    }
  }
};
