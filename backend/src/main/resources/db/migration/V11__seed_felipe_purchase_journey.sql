-- V11__seed_felipe_purchase_journey.sql
-- Realistic scenario: Felipe buying a R$250k house in Jardim Romano (cash/quitação)
-- This simulates the full intermediation flow the platform provides

-- 1. Buyer (Felipe) as a customer of WFJ Imóveis
INSERT INTO customers (id, tenant_id, name, email, phone, cpf, rg, marital_status, monthly_income, fgts_balance, profile, status, source) VALUES
    ('00000000-0000-0000-0000-000000000050', '00000000-0000-0000-0000-000000000003',
     'Felipe Lima', 'felipemjl08@gmail.com', '11999998888', '123.456.789-00', '12.345.678-9',
     'SOLTEIRO', 12000.00, 45000.00,
     '{"type": "HOUSE", "min_rooms": 2, "neighborhoods": ["Jardim Romano"], "max_price": 300000}'::jsonb,
     'ACTIVE', 'INDICACAO')
ON CONFLICT (id) DO NOTHING;

-- 2. Seller as a customer contact (the owner)
INSERT INTO customers (id, tenant_id, name, email, phone, cpf, marital_status, monthly_income, status, source) VALUES
    ('00000000-0000-0000-0000-000000000051', '00000000-0000-0000-0000-000000000003',
     'Roberto Mendes (Vendedor)', 'roberto.mendes@email.com', '11988887766', '987.654.321-00',
     'CASADO', 8000.00, 'ACTIVE', 'CAPTACAO_DIRETA')
ON CONFLICT (id) DO NOTHING;

-- 3. The property being purchased (Sobrado in Jardim Romano, R$250k)
INSERT INTO properties (id, tenant_id, title, type, status, address_street, address_number, address_neighborhood, address_city, address_state, address_zip, area_total_m2, area_built_m2, bedrooms, bathrooms, parking_spots, price, description, features, registration_number) VALUES
    ('00000000-0000-0000-0000-000000000025', '00000000-0000-0000-0000-000000000003',
     'Sobrado 3 Quartos - Rua Cachoeira Tijuco', 'HOUSE', 'RESERVED',
     'Rua Cachoeira Tijuco', '215', 'Jardim Romano', 'São Paulo', 'SP', '08111-620',
     180.00, 130.00, 3, 2, 1, 250000.00,
     'Sobrado bem conservado com 3 dormitórios (1 suíte), sala ampla, cozinha planejada, quintal com churrasqueira e 1 vaga de garagem. Documentação em dia, pronto para escriturar. Próximo à estação CPTM Jardim Romano e comércio local.',
     '["Suíte", "Churrasqueira", "Cozinha planejada", "Quintal", "Próximo ao trem", "Documentação OK"]'::jsonb,
     'MAT-123456-CRI-SP')
ON CONFLICT (id) DO NOTHING;

-- 4. Journey: Felipe's purchase journey — status CONTRACT_SIGNED (contract already signed)
INSERT INTO journeys (id, tenant_id, customer_id, property_id, broker_id, status, started_at) VALUES
    ('00000000-0000-0000-0000-000000000060', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000050',  -- Felipe (buyer)
     '00000000-0000-0000-0000-000000000025',  -- Sobrado Cachoeira Tijuco
     '00000000-0000-0000-0000-000000000007',  -- Broker WFJ
     'CONTRACT_SIGNED',
     '2026-06-10 10:00:00+00')
ON CONFLICT (id) DO NOTHING;

-- 5. Proposal: The accepted purchase proposal (R$250k, full cash)
INSERT INTO proposals (id, tenant_id, journey_id, property_id, customer_id, offer_amount, conditions, status, created_by) VALUES
    ('00000000-0000-0000-0000-000000000070', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     '00000000-0000-0000-0000-000000000025',
     '00000000-0000-0000-0000-000000000050',
     250000.00,
     '{
       "payment_method": "CASH_FULL",
       "payment_description": "Pagamento à vista na quitação integral",
       "seller_name": "Roberto Mendes",
       "seller_cpf": "987.654.321-00",
       "seller_spouse": "Maria Aparecida Mendes",
       "closing_costs": {
         "itbi_estimated": 7500.00,
         "escritura_estimated": 3200.00,
         "registro_estimated": 2517.00,
         "certidoes_estimated": 600.00,
         "total_estimated": 13817.00
       },
       "contract_clauses": [
         "Quitação integral no ato da escritura",
         "Vendedor se compromete a apresentar certidões negativas válidas",
         "Entrega das chaves em até 30 dias após registro",
         "Vendedor responsável por débitos de IPTU até a data da escritura"
       ]
     }'::jsonb,
     'ACCEPTED',
     '00000000-0000-0000-0000-000000000007')
ON CONFLICT (id) DO NOTHING;

-- 6. Timeline events: The full journey history so far
INSERT INTO timeline_events (id, tenant_id, journey_id, type, title, description, metadata, created_by, created_at) VALUES
    -- Step 1: Lead captured
    ('00000000-0000-0000-0000-000000000080', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'LEAD_CAPTURED', 'Lead Capturado',
     'Felipe Lima demonstrou interesse em imóveis no Jardim Romano, faixa de até R$300k.',
     '{"source": "indicacao", "channel": "whatsapp"}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-10 10:00:00+00'),

    -- Step 2: Visit scheduled
    ('00000000-0000-0000-0000-000000000081', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'VISIT_SCHEDULED', 'Visita Agendada',
     'Agendada visita ao Sobrado na Rua Cachoeira Tijuco, 215 para 12/06/2026 às 14h.',
     '{"visit_date": "2026-06-12T14:00:00", "property_title": "Sobrado 3 Quartos - Rua Cachoeira Tijuco"}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-10 15:30:00+00'),

    -- Step 3: Visit done
    ('00000000-0000-0000-0000-000000000082', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'VISIT_COMPLETED', 'Visita Realizada',
     'Felipe visitou o imóvel e aprovou. Demonstrou interesse imediato em fazer proposta.',
     '{"feedback": "Gostou muito da churrasqueira e da proximidade com o trem. Pediu detalhes de documentação."}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-12 16:00:00+00'),

    -- Step 4: Due diligence
    ('00000000-0000-0000-0000-000000000083', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'DUE_DILIGENCE', 'Análise Documental Concluída',
     'Verificação automática: matrícula limpa, sem ônus, IPTU em dia, certidões do vendedor OK.',
     '{"risk_score": "GREEN", "matricula_status": "CLEAN", "iptu_status": "PAID", "seller_certidoes": "ALL_CLEAR", "alerts": []}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-13 10:00:00+00'),

    -- Step 5: Proposal sent
    ('00000000-0000-0000-0000-000000000084', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'PROPOSAL_SENT', 'Proposta Enviada ao Vendedor',
     'Proposta de R$250.000,00 (pagamento à vista) enviada ao proprietário Roberto Mendes.',
     '{"offer_amount": 250000, "payment_method": "CASH_FULL"}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-14 09:00:00+00'),

    -- Step 6: Proposal accepted
    ('00000000-0000-0000-0000-000000000085', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'PROPOSAL_ACCEPTED', 'Proposta Aceita pelo Vendedor',
     'Roberto Mendes aceitou a proposta de R$250.000,00. Próximo passo: elaboração do contrato de compra e venda.',
     '{"accepted_at": "2026-06-15T11:00:00", "seller_response": "Aceito nas condições propostas"}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-15 11:00:00+00'),

    -- Step 7: Contract generated
    ('00000000-0000-0000-0000-000000000086', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'CONTRACT_GENERATED', 'Contrato de Compra e Venda Gerado',
     'Contrato particular de compromisso de compra e venda gerado automaticamente pela plataforma com dados do comprador, vendedor e imóvel.',
     '{"contract_type": "COMPROMISSO_COMPRA_VENDA", "generated_by": "PLATFORM", "template_version": "v2.1"}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-16 10:00:00+00'),

    -- Step 8: Contract signed digitally
    ('00000000-0000-0000-0000-000000000087', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'CONTRACT_SIGNED', 'Contrato Assinado Digitalmente',
     'Contrato assinado por ambas as partes via assinatura eletrônica avançada. Validade jurídica conforme Lei 14.063/2020.',
     '{"signed_by_buyer": "2026-06-17T14:00:00", "signed_by_seller": "2026-06-17T16:30:00", "signature_method": "CLICKSIGN", "audit_trail_id": "CS-2026-0617-ABC123"}'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-17 16:30:00+00'),

    -- Step 9: NEXT STEPS (pending - what Felipe needs to do now)
    ('00000000-0000-0000-0000-000000000088', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000060',
     'CHECKLIST_UPDATED', '📋 Próximos Passos após Contrato Assinado',
     'A plataforma gerou automaticamente o checklist dos próximos passos para concretizar a transferência do imóvel.',
     '{
       "next_steps": [
         {"step": 1, "title": "Pagar ITBI", "description": "Emitir guia DAMSP no portal da Prefeitura de SP e pagar o ITBI (3% = R$7.500,00). A plataforma gera o link direto.", "status": "PENDING", "deadline": "2026-07-01", "estimated_cost": 7500.00},
         {"step": 2, "title": "Agendar Escritura Pública", "description": "Comparecer a um Tabelionato de Notas com comprador, vendedor (e cônjuge), RG, CPF, certidão de casamento do vendedor e comprovante de ITBI pago.", "status": "PENDING", "deadline": "2026-07-10", "estimated_cost": 3200.00},
         {"step": 3, "title": "Lavrar Escritura Pública", "description": "O tabelião lavra a escritura definitiva de compra e venda. Ambas as partes assinam. É necessário apresentar certidões atualizadas (máx 30 dias).", "status": "PENDING", "deadline": "2026-07-15", "estimated_cost": 0},
         {"step": 4, "title": "Registrar no CRI", "description": "Levar a escritura pública + comprovante de ITBI ao Cartório de Registro de Imóveis para averbação na matrícula. Prazo: 20-30 dias.", "status": "PENDING", "deadline": "2026-07-20", "estimated_cost": 2517.00},
         {"step": 5, "title": "Receber Matrícula Atualizada", "description": "Após registro, solicitar nova matrícula com seu nome como proprietário. A transferência está concluída!", "status": "PENDING", "deadline": "2026-08-20", "estimated_cost": 60.00},
         {"step": 6, "title": "Receber Chaves", "description": "Conforme contrato, o vendedor entrega as chaves em até 30 dias após o registro.", "status": "PENDING", "deadline": "2026-09-01", "estimated_cost": 0}
       ],
       "total_closing_costs": 13277.00,
       "documents_required_buyer": ["RG", "CPF", "Comprovante de residência", "Certidão de estado civil", "Comprovante de pagamento ITBI"],
       "documents_required_seller": ["RG", "CPF", "Certidão de casamento", "Certidões negativas (cível, criminal, trabalhista, fiscal)", "Comprovante de quitação IPTU"],
       "documents_required_property": ["Matrícula atualizada (max 30 dias)", "Certidão de ônus reais", "Habite-se"]
     }'::jsonb,
     '00000000-0000-0000-0000-000000000007', '2026-06-18 09:00:00+00')
ON CONFLICT (id) DO NOTHING;

-- 7. Notifications for Felipe
INSERT INTO notifications (id, tenant_id, customer_id, channel, type, title, body, status, created_at) VALUES
    ('00000000-0000-0000-0000-000000000090', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000050',
     'WHATSAPP', 'JOURNEY_UPDATE',
     '🎉 Contrato assinado com sucesso!',
     'Olá Felipe! Seu contrato de compra do imóvel na Rua Cachoeira Tijuco, 215 foi assinado por ambas as partes. Acesse a plataforma para ver os próximos passos: pagamento do ITBI, escritura e registro.',
     'SENT', '2026-06-17 17:00:00+00'),

    ('00000000-0000-0000-0000-000000000091', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000050',
     'EMAIL', 'CLOSING_COSTS',
     '💰 Resumo de custos para finalizar sua compra',
     'Felipe, aqui está o resumo dos custos de fechamento do seu imóvel: ITBI: R$7.500 | Escritura: ~R$3.200 | Registro CRI: ~R$2.517 | Certidões: ~R$600 | Total estimado: ~R$13.817. A plataforma acompanha cada etapa com você!',
     'SENT', '2026-06-18 09:30:00+00'),

    ('00000000-0000-0000-0000-000000000092', '00000000-0000-0000-0000-000000000003',
     '00000000-0000-0000-0000-000000000050',
     'WHATSAPP', 'ACTION_REQUIRED',
     '⏰ Ação necessária: Pagar ITBI até 01/07',
     'Felipe, o próximo passo da sua jornada é o pagamento do ITBI (R$7.500). Acesse o link para gerar a guia DAMSP: https://itbi.prefeitura.sp.gov.br/. Prazo sugerido: 01/07/2026.',
     'PENDING', '2026-06-22 10:00:00+00')
ON CONFLICT (id) DO NOTHING;
