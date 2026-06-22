package com.imobflow.customer.model;

import com.imobflow.shared.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Customer/Buyer entity representing a potential property buyer.
 */
@Entity
@Table(name = "customers")
@Getter
@Setter
public class Customer extends BaseEntity {

    @Column(nullable = false)
    private String name;

    private String email;

    @Column(length = 20)
    private String phone;

    @Column(length = 14)
    private String cpf;

    @Column(length = 20)
    private String rg;

    @Column(name = "marital_status", length = 30)
    private String maritalStatus;

    @Column(name = "monthly_income")
    private BigDecimal monthlyIncome;

    @Column(name = "fgts_balance")
    private BigDecimal fgtsBalance;

    /** Desired property profile: {type, min_price, max_price, min_rooms, neighborhoods[]} */
    @Column(columnDefinition = "jsonb")
    private String profile = "{}";

    @Column(length = 30)
    @Enumerated(EnumType.STRING)
    private CustomerStatus status = CustomerStatus.LEAD;

    @Column(length = 50)
    private String source;

    @Column(name = "assigned_broker")
    private UUID assignedBroker;
}
