package com.imobflow.journey.service;

import com.imobflow.journey.dto.CreateJourneyDTO;
import com.imobflow.journey.dto.JourneyDTO;
import com.imobflow.journey.dto.TimelineEventDTO;
import com.imobflow.journey.model.Journey;
import com.imobflow.journey.model.JourneyStatus;
import com.imobflow.journey.model.TimelineEvent;
import com.imobflow.journey.repository.JourneyRepository;
import com.imobflow.journey.repository.TimelineEventRepository;
import com.imobflow.proposal.dto.ProposalDTO;
import com.imobflow.proposal.model.Proposal;
import com.imobflow.proposal.repository.ProposalRepository;
import com.imobflow.shared.exception.ResourceNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class JourneyService {

    private final JourneyRepository journeyRepository;
    private final TimelineEventRepository timelineEventRepository;
    private final ProposalRepository proposalRepository;

    public JourneyService(JourneyRepository journeyRepository,
                          TimelineEventRepository timelineEventRepository,
                          ProposalRepository proposalRepository) {
        this.journeyRepository = journeyRepository;
        this.timelineEventRepository = timelineEventRepository;
        this.proposalRepository = proposalRepository;
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

    @Transactional(readOnly = true)
    public List<TimelineEventDTO> getTimelineEvents(UUID journeyId) {
        if (!journeyRepository.existsById(journeyId)) {
            throw new ResourceNotFoundException("Journey not found with id: " + journeyId);
        }
        // Ordered by createdAt Ascending or Descending? Ascending is usually better for sequential reading, but let's match repo which is desc.
        // Let's use Descending as in repo, or sort it in memory if needed. The repo has findByJourneyIdOrderByCreatedAtDesc, but actually let's sort Ascending or just return what the repository has (desc).
        // Let's return what repository has (descending).
        return timelineEventRepository.findByJourneyIdOrderByCreatedAtDesc(journeyId)
                .stream()
                .map(this::convertToTimelineEventDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ProposalDTO> getProposals(UUID journeyId) {
        if (!journeyRepository.existsById(journeyId)) {
            throw new ResourceNotFoundException("Journey not found with id: " + journeyId);
        }
        return proposalRepository.findByJourneyId(journeyId)
                .stream()
                .map(this::convertToProposalDTO)
                .collect(Collectors.toList());
    }

    private TimelineEventDTO convertToTimelineEventDTO(TimelineEvent event) {
        return new TimelineEventDTO(
                event.getId(),
                event.getTenantId(),
                event.getJourneyId(),
                event.getType(),
                event.getTitle(),
                event.getDescription(),
                event.getMetadata(),
                event.getCreatedBy(),
                event.getCreatedAt()
        );
    }

    private ProposalDTO convertToProposalDTO(Proposal proposal) {
        return new ProposalDTO(
                proposal.getId(),
                proposal.getTenantId(),
                proposal.getJourneyId(),
                proposal.getPropertyId(),
                proposal.getCustomerId(),
                proposal.getOfferAmount(),
                proposal.getConditions(),
                proposal.getStatus(),
                proposal.getValidUntil(),
                proposal.getCreatedBy(),
                proposal.getCreatedAt(),
                proposal.getUpdatedAt()
        );
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
