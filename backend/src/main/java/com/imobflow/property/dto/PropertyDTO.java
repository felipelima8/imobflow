package com.imobflow.property.dto;

import com.imobflow.property.model.PropertyStatus;
import com.imobflow.property.model.PropertyType;
import java.math.BigDecimal;
import java.util.UUID;

public record PropertyDTO(
    UUID id,
    UUID tenantId,
    String title,
    PropertyType type,
    PropertyStatus status,
    String addressStreet,
    String addressNumber,
    String addressComplement,
    String addressNeighborhood,
    String addressCity,
    String addressState,
    String addressZip,
    BigDecimal latitude,
    BigDecimal longitude,
    BigDecimal areaTotalM2,
    BigDecimal areaBuiltM2,
    Integer bedrooms,
    Integer bathrooms,
    Integer parkingSpots,
    BigDecimal price,
    BigDecimal condoFee,
    BigDecimal iptuAnnual,
    String description,
    String features,
    String registrationNumber
) {}
