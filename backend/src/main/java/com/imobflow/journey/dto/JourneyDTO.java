package com.imobflow.journey.dto;

import com.imobflow.journey.model.JourneyStatus;
import java.time.Instant;
import java.util.UUID;

public record JourneyDTO(
    UUID id,
    UUID tenantId,
    UUID customerId,
    UUID propertyId,
    UUID brokerId,
    JourneyStatus status,
    Instant startedAt,
    Instant closedAt
) {}
