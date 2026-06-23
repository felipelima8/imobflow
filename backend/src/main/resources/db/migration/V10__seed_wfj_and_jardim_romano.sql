-- V10__seed_wfj_and_jardim_romano.sql
-- Seed tenant "WFJ Imóveis"
INSERT INTO tenants (id, slug, name, plan_id, is_active) VALUES
    ('00000000-0000-0000-0000-000000000003', 'wfj', 'WFJ Imóveis', 'professional', true)
ON CONFLICT (id) DO NOTHING;

-- Seed broker for "WFJ Imóveis"
INSERT INTO users (id, tenant_id, email, name, role, is_active) VALUES
    ('00000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-000000000003', 'contato@wfj.com.br', 'Broker WFJ', 'BROKER', true)
ON CONFLICT (id) DO NOTHING;

-- Seed customers for "WFJ Imóveis"
INSERT INTO customers (id, tenant_id, name, email, phone, monthly_income, fgts_balance, status) VALUES
    ('00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000003', 'João da Silva', 'joao.silva@gmail.com', '11988887777', 6500.00, 15000.00, 'ACTIVE'),
    ('00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000003', 'Maria Oliveira', 'maria.oliveira@outlook.com', '11977776666', 8200.00, 24000.00, 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

-- Seed properties in Jardim Romano for "WFJ Imóveis"
INSERT INTO properties (id, tenant_id, title, type, status, address_street, address_number, address_neighborhood, address_city, address_state, address_zip, area_total_m2, area_built_m2, bedrooms, bathrooms, parking_spots, price, description, features) VALUES
    ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000003', 'Casa de Condomínio - Jardim Romano', 'HOUSE', 'AVAILABLE', 'Rua Manuel Félix de Lima', '142', 'Jardim Romano', 'São Paulo', 'SP', '08111-600', 120.00, 90.00, 2, 2, 1, 220000.00, 'Excelente casa de condomínio fechado, bem localizada no Jardim Romano, a poucos minutos a pé da Estação Jardim Romano da CPTM. Possui 2 dormitórios, sala aconchegante, cozinha americana e 1 vaga.', '["Próximo ao trem", "Condomínio fechado", "Cozinha Americana"]'::jsonb),
    ('00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000003', 'Sobrado Espaçoso - Jardim Romano', 'HOUSE', 'AVAILABLE', 'Avenida Tomás Lopes de Camargo', '820', 'Jardim Romano', 'São Paulo', 'SP', '08111-590', 200.00, 160.00, 3, 3, 2, 350000.00, 'Sobrado amplo com 3 dormitórios (1 suíte), churrasqueira no quintal e vaga para 2 carros. Localizado em uma das principais avenidas do Jardim Romano com fácil acesso a mercados e transporte.', '["Churrasqueira", "Suíte", "Quintal Grande", "Garagem"]'::jsonb),
    ('00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000003', 'Apartamento Residencial Romano', 'APARTMENT', 'AVAILABLE', 'Rua José Álvares Moreira', '300', 'Jardim Romano', 'São Paulo', 'SP', '08191-300', 65.00, 65.00, 2, 1, 1, 180000.00, 'Lindo apartamento com 2 quartos, sala de estar com sacada, área de lazer no condomínio com playground e salão de festas. Muito próximo à estação da CPTM Jardim Romano.', '["Sacada", "Playground", "Salão de festas", "Próximo à estação"]'::jsonb),
    ('00000000-0000-0000-0000-000000000023', '00000000-0000-0000-0000-000000000003', 'Terreno Comercial - Romano Central', 'LAND', 'AVAILABLE', 'Rua André Furtado de Mendonça', '55', 'Jardim Romano', 'São Paulo', 'SP', '08111-650', 250.00, 0.00, 0, 0, 0, 150000.00, 'Terreno plano ideal para comércio ou construção de salão comercial, no coração do Jardim Romano. Próximo a comércios variados.', '["Terreno plano", "Excelente localização comercial"]'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- Seed journeys for "WFJ Imóveis"
INSERT INTO journeys (id, tenant_id, customer_id, property_id, broker_id, status) VALUES
    ('00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000007', 'STARTED'),
    ('00000000-0000-0000-0000-000000000041', '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000007', 'FINANCING_APPROVED')
ON CONFLICT (id) DO NOTHING;
