package com.imobflow.customer.dto;

import jakarta.validation.constraints.NotBlank;
import java.math.BigDecimal;
import java.util.UUID;

public record CreateCustomerDTO(
    @NotBlank(message = "Name is required")
    String name,
    String email,
    String phone,
    String cpf,
    String rg,
    String maritalStatus,
    BigDecimal monthlyIncome,
    BigDecimal fgtsBalance,
    String profile,
    String source,
    UUID assignedBroker
) {}
