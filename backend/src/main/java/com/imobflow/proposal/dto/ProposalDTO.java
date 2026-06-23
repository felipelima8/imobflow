package com.imobflow.proposal.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record ProposalDTO(
        UUID id,
        UUID tenantId,
        UUID journeyId,
        UUID propertyId,
        UUID customerId,
        BigDecimal offerAmount,
        String conditions,
        String status,
        Instant validUntil,
        UUID createdBy,
        Instant createdAt,
        Instant updatedAt
) {}
