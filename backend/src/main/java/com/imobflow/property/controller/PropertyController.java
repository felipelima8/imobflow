package com.imobflow.property.controller;

import com.imobflow.property.dto.CreatePropertyDTO;
import com.imobflow.property.dto.PropertyDTO;
import com.imobflow.property.model.PropertyType;
import com.imobflow.property.service.PropertyService;
import com.imobflow.identity.TenantContext;
import com.imobflow.shared.dto.PaginatedResponse;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/properties")
public class PropertyController {

    private final PropertyService propertyService;

    public PropertyController(PropertyService propertyService) {
        this.propertyService = propertyService;
    }

    @GetMapping
    public ResponseEntity<PaginatedResponse<PropertyDTO>> getProperties(
            @RequestParam(required = false) PropertyType type,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Integer minBedrooms,
            @RequestParam(required = false) String city,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<PropertyDTO> propertiesPage = propertyService.searchProperties(
                type, minPrice, maxPrice, minBedrooms, city, PageRequest.of(page, size));
        var response = new PaginatedResponse<>(
                propertiesPage.getContent(),
                propertiesPage.getNumber(),
                propertiesPage.getSize(),
                propertiesPage.getTotalElements(),
                propertiesPage.getTotalPages(),
                propertiesPage.hasNext()
        );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PropertyDTO> getPropertyById(@PathVariable UUID id) {
        return ResponseEntity.ok(propertyService.getPropertyById(id));
    }

    @PostMapping
    public ResponseEntity<PropertyDTO> createProperty(@Valid @RequestBody CreatePropertyDTO dto) {
        UUID tenantId = TenantContext.getCurrentTenantId();
        if (tenantId == null) {
            tenantId = UUID.fromString("00000000-0000-0000-0000-000000000001");
        }
        PropertyDTO created = propertyService.createProperty(dto, tenantId);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PropertyDTO> updateProperty(
            @PathVariable UUID id,
            @Valid @RequestBody CreatePropertyDTO dto) {
        return ResponseEntity.ok(propertyService.updateProperty(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProperty(@PathVariable UUID id) {
        propertyService.deleteProperty(id);
        return ResponseEntity.noContent().build();
    }
}
