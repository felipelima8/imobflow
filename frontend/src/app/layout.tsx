import type { Metadata, Viewport } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "ImobFlow — A Jornada de Compra de Imóveis Colaborativa e Guiada por IA",
  description: "Plataforma SaaS imobiliária open-source inspirada no modelo da Contabilizei. Gerencie a jornada do comprador, simulações de financiamento, OCR de documentos e análise jurídica em um só lugar.",
  keywords: ["SaaS imobiliário", "CRM imobiliário", "Open Source", "Inteligência Artificial", "Financiamento Imobiliário", "Multi-tenancy"],
  authors: [{ name: "ImobFlow Core Team" }],
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR">
      <body id="imobflow-root-container">
        <main id="imobflow-main-viewport">
          {children}
        </main>
      </body>
    </html>
  );
}
