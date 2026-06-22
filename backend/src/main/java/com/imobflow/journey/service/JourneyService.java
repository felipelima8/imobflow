package com.imobflow.journey.service;

import com.imobflow.journey.dto.CreateJourneyDTO;
import com.imobflow.journey.dto.JourneyDTO;
import com.imobflow.journey.model.Journey;
import com.imobflow.journey.model.JourneyStatus;
import com.imobflow.journey.repository.JourneyRepository;
import com.imobflow.shared.exception.ResourceNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Service
public class JourneyService {

    private final JourneyRepository journeyRepository;

    public JourneyService(JourneyRepository journeyRepository) {
        this.journeyRepository = journeyRepository;
    }

    @Transactional(readOnly = true)
    public Page<JourneyDTO> getJourneys(UUID brokerId, Pageable pageable) {
        return journeyRepository.findByBrokerId(brokerId, pageable)
                .map(this::convertToDTO);
    }

    @Transactional(readOnly = true)
    public JourneyDTO getJourneyById(UUID id) {
        return journeyRepository.findById(id)
                .map(this::convertToDTO)
                .orElseThrow(() -> new ResourceNotFoundException("Journey not found with id: " + id));
    }

    @Transactional
    public JourneyDTO createJourney(CreateJourneyDTO dto, UUID tenantId) {
        Journey journey = new Journey();
        journey.setTenantId(tenantId);
        journey.setCustomerId(dto.customerId());
        journey.setPropertyId(dto.propertyId());
        journey.setBrokerId(dto.brokerId());
        journey.setStatus(JourneyStatus.STARTED);
        journey.setStartedAt(Instant.now());

        Journey saved = journeyRepository.save(journey);
        return convertToDTO(saved);
    }

    @Transactional
    public JourneyDTO updateJourneyStatus(UUID id, JourneyStatus status) {
        Journey journey = journeyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Journey not found with id: " + id));

        journey.setStatus(status);
        if (status == JourneyStatus.COMPLETED || status == JourneyStatus.CANCELLED) {
            journey.setClosedAt(Instant.now());
        }

        Journey updated = journeyRepository.save(journey);
        return convertToDTO(updated);
    }

    @Transactional
    public void deleteJourney(UUID id) {
        if (!journeyRepository.existsById(id)) {
            throw new ResourceNotFoundException("Journey not found with id: " + id);
        }
        journeyRepository.deleteById(id);
    }

    private JourneyDTO convertToDTO(Journey journey) {
        return new JourneyDTO(
                journey.getId(),
                journey.getTenantId(),
                journey.getCustomerId(),
                journey.getPropertyId(),
                journey.getBrokerId(),
                journey.getStatus(),
                journey.getStartedAt(),
                journey.getClosedAt()
        );
    }
}
