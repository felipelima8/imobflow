package com.imobflow.journey.dto;

import jakarta.validation.constraints.NotNull;
import java.util.UUID;

public record CreateJourneyDTO(
    @NotNull(message = "CustomerId is required")
    UUID customerId,
    UUID propertyId,
    @NotNull(message = "BrokerId is required")
    UUID brokerId
) {}
