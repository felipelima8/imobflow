package com.imobflow.document.dto;

import java.time.Instant;
import java.util.UUID;

public record DocumentDTO(
        UUID id,
        UUID tenantId,
        UUID journeyId,
        String title,
        String type,
        String filePath,
        Long fileSize,
        String status,
        UUID uploadedBy,
        Instant createdAt,
        Instant updatedAt
) {}
