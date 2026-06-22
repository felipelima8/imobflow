package com.imobflow.journey.repository;

import com.imobflow.journey.model.Journey;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface JourneyRepository extends JpaRepository<Journey, UUID> {
    Page<Journey> findByBrokerId(UUID brokerId, Pageable pageable);
    List<Journey> findByCustomerId(UUID customerId);
    long countByBrokerIdAndStatus(UUID brokerId, String status);
}
