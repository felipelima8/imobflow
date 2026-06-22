package com.imobflow.property.model;

import com.imobflow.shared.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Property listing entity.
 */
@Entity
@Table(name = "properties")
@Getter
@Setter
public class Property extends BaseEntity {

    @Column(nullable = false)
    private String title;

    @Column(nullable = false, length = 50)
    @Enumerated(EnumType.STRING)
    private PropertyType type;

    @Column(length = 30)
    @Enumerated(EnumType.STRING)
    private PropertyStatus status = PropertyStatus.AVAILABLE;

    @Column(name = "address_street") private String addressStreet;
    @Column(name = "address_number", length = 20) private String addressNumber;
    @Column(name = "address_complement", length = 100) private String addressComplement;
    @Column(name = "address_neighborhood", length = 100) private String addressNeighborhood;
    @Column(name = "address_city", length = 100) private String addressCity;
    @Column(name = "address_state", length = 2) private String addressState;
    @Column(name = "address_zip", length = 10) private String addressZip;

    private BigDecimal latitude;
    private BigDecimal longitude;

    @Column(name = "area_total_m2") private BigDecimal areaTotalM2;
    @Column(name = "area_built_m2") private BigDecimal areaBuiltM2;

    private Integer bedrooms;
    private Integer bathrooms;
    @Column(name = "parking_spots") private Integer parkingSpots;

    private BigDecimal price;
    @Column(name = "condo_fee") private BigDecimal condoFee;
    @Column(name = "iptu_annual") private BigDecimal iptuAnnual;

    @Column(columnDefinition = "text")
    private String description;

    /** Features array: ["pool", "gym", "balcony"] */
    @Column(columnDefinition = "jsonb")
    private String features = "[]";

    @Column(name = "registration_number", length = 50)
    private String registrationNumber;
}
