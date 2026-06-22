package com.imobflow.customer.dto;

import com.imobflow.customer.model.CustomerStatus;
import java.math.BigDecimal;
import java.util.UUID;

public record CustomerDTO(
    UUID id,
    UUID tenantId,
    String name,
    String email,
    String phone,
    String cpf,
    String rg,
    String maritalStatus,
    BigDecimal monthlyIncome,
    BigDecimal fgtsBalance,
    String profile,
    CustomerStatus status,
    String source,
    UUID assignedBroker
) {}
