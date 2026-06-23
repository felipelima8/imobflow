package com.imobflow.journey.dto;

import java.time.Instant;
import java.util.UUID;

public record TimelineEventDTO(
        UUID id,
        UUID tenantId,
        UUID journeyId,
        String type,
        String title,
        String description,
        String metadata,
        UUID createdBy,
        Instant createdAt
) {}
