package com.imobflow.journey.controller;

import com.imobflow.journey.dto.CreateJourneyDTO;
import com.imobflow.journey.dto.JourneyDTO;
import com.imobflow.journey.model.JourneyStatus;
import com.imobflow.journey.service.JourneyService;
import com.imobflow.identity.TenantContext;
import com.imobflow.shared.dto.PaginatedResponse;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.imobflow.journey.dto.TimelineEventDTO;
import com.imobflow.proposal.dto.ProposalDTO;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/journeys")
public class JourneyController {

    private final JourneyService journeyService;

    public JourneyController(JourneyService journeyService) {
        this.journeyService = journeyService;
    }

    @GetMapping
    public ResponseEntity<PaginatedResponse<JourneyDTO>> getJourneys(
            @RequestParam UUID brokerId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<JourneyDTO> journeysPage = journeyService.getJourneys(brokerId, PageRequest.of(page, size));
        var response = new PaginatedResponse<>(
                journeysPage.getContent(),
                journeysPage.getNumber(),
                journeysPage.getSize(),
                journeysPage.getTotalElements(),
                journeysPage.getTotalPages(),
                journeysPage.hasNext()
        );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<JourneyDTO> getJourneyById(@PathVariable UUID id) {
        return ResponseEntity.ok(journeyService.getJourneyById(id));
    }

    @PostMapping
    public ResponseEntity<JourneyDTO> createJourney(@Valid @RequestBody CreateJourneyDTO dto) {
        UUID tenantId = TenantContext.getCurrentTenantId();
        if (tenantId == null) {
            tenantId = UUID.fromString("00000000-0000-0000-0000-000000000001");
        }
        JourneyDTO created = journeyService.createJourney(dto, tenantId);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<JourneyDTO> updateJourneyStatus(
            @PathVariable UUID id,
            @RequestParam JourneyStatus status) {
        return ResponseEntity.ok(journeyService.updateJourneyStatus(id, status));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteJourney(@PathVariable UUID id) {
        journeyService.deleteJourney(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/timeline")
    public ResponseEntity<List<TimelineEventDTO>> getJourneyTimeline(@PathVariable UUID id) {
        return ResponseEntity.ok(journeyService.getTimelineEvents(id));
    }

    @GetMapping("/{id}/proposals")
    public ResponseEntity<List<ProposalDTO>> getJourneyProposals(@PathVariable UUID id) {
        return ResponseEntity.ok(journeyService.getProposals(id));
    }
}
