package com.imobflow.property.dto;

import com.imobflow.property.model.PropertyType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record CreatePropertyDTO(
    @NotBlank(message = "Title is required")
    String title,
    @NotNull(message = "Property type is required")
    PropertyType type,
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
    @NotNull(message = "Price is required")
    BigDecimal price,
    BigDecimal condoFee,
    BigDecimal iptuAnnual,
    String description,
    String features,
    String registrationNumber
) {}
