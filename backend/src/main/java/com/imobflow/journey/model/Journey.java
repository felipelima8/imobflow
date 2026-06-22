package com.imobflow.journey.model;

import com.imobflow.shared.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;
import java.util.UUID;

/**
 * Represents a buyer's purchase journey — the core domain entity.
 */
@Entity
@Table(name = "journeys")
@Getter
@Setter
public class Journey extends BaseEntity {

    @Column(name = "customer_id", nullable = false)
    private UUID customerId;

    @Column(name = "property_id")
    private UUID propertyId;

    @Column(name = "broker_id", nullable = false)
    private UUID brokerId;

    @Column(length = 30)
    @Enumerated(EnumType.STRING)
    private JourneyStatus status = JourneyStatus.STARTED;

    @Column(name = "started_at")
    private Instant startedAt;

    @Column(name = "closed_at")
    private Instant closedAt;

    @PrePersist
    @Override
    protected void onCreate() {
        super.onCreate();
        if (startedAt == null) {
            startedAt = Instant.now();
        }
    }
}
