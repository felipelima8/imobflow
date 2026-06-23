package com.imobflow.proposal.model;

import com.imobflow.shared.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "proposals")
@Getter
@Setter
public class Proposal extends BaseEntity {

    @Column(name = "journey_id", nullable = false)
    private UUID journeyId;

    @Column(name = "property_id", nullable = false)
    private UUID propertyId;

    @Column(name = "customer_id", nullable = false)
    private UUID customerId;

    @Column(name = "offer_amount", nullable = false)
    private BigDecimal offerAmount;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(columnDefinition = "jsonb")
    private String conditions = "{}";

    @Column(length = 30)
    private String status = "DRAFT";

    @Column(name = "valid_until")
    private Instant validUntil;

    @Column(name = "created_by")
    private UUID createdBy;
}
