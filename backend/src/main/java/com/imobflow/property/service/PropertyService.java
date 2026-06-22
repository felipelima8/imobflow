package com.imobflow.property.service;

import com.imobflow.property.dto.CreatePropertyDTO;
import com.imobflow.property.dto.PropertyDTO;
import com.imobflow.property.model.Property;
import com.imobflow.property.model.PropertyStatus;
import com.imobflow.property.model.PropertyType;
import com.imobflow.property.repository.PropertyRepository;
import com.imobflow.shared.exception.ResourceNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.UUID;

@Service
public class PropertyService {

    private final PropertyRepository propertyRepository;

    public PropertyService(PropertyRepository propertyRepository) {
        this.propertyRepository = propertyRepository;
    }

    @Transactional(readOnly = true)
    public Page<PropertyDTO> searchProperties(
            PropertyType type,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            Integer minBedrooms,
            String city,
            Pageable pageable) {
        return propertyRepository.search(type, minPrice, maxPrice, minBedrooms, city, pageable)
                .map(this::convertToDTO);
    }

    @Transactional(readOnly = true)
    public PropertyDTO getPropertyById(UUID id) {
        return propertyRepository.findById(id)
                .map(this::convertToDTO)
                .orElseThrow(() -> new ResourceNotFoundException("Property not found with id: " + id));
    }

    @Transactional
    public PropertyDTO createProperty(CreatePropertyDTO dto, UUID tenantId) {
        Property property = new Property();
        property.setTenantId(tenantId);
        updatePropertyFields(property, dto);
        property.setStatus(PropertyStatus.AVAILABLE);

        Property saved = propertyRepository.save(property);
        return convertToDTO(saved);
    }

    @Transactional
    public PropertyDTO updateProperty(UUID id, CreatePropertyDTO dto) {
        Property property = propertyRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Property not found with id: " + id));

        updatePropertyFields(property, dto);
        Property updated = propertyRepository.save(property);
        return convertToDTO(updated);
    }

    @Transactional
    public void deleteProperty(UUID id) {
        if (!propertyRepository.existsById(id)) {
            throw new ResourceNotFoundException("Property not found with id: " + id);
        }
        propertyRepository.deleteById(id);
    }

    private void updatePropertyFields(Property property, CreatePropertyDTO dto) {
        property.setTitle(dto.title());
        property.setType(dto.type());
        property.setAddressStreet(dto.addressStreet());
        property.setAddressNumber(dto.addressNumber());
        property.setAddressComplement(dto.addressComplement());
        property.setAddressNeighborhood(dto.addressNeighborhood());
        property.setAddressCity(dto.addressCity());
        property.setAddressState(dto.addressState());
        property.setAddressZip(dto.addressZip());
        property.setLatitude(dto.latitude());
        property.setLongitude(dto.longitude());
        property.setAreaTotalM2(dto.areaTotalM2());
        property.setAreaBuiltM2(dto.areaBuiltM2());
        property.setBedrooms(dto.bedrooms());
        property.setBathrooms(dto.bathrooms());
        property.setParkingSpots(dto.parkingSpots());
        property.setPrice(dto.price());
        property.setCondoFee(dto.condoFee());
        property.setIptuAnnual(dto.iptuAnnual());
        property.setDescription(dto.description());
        property.setFeatures(dto.features() != null ? dto.features() : "[]");
        property.setRegistrationNumber(dto.registrationNumber());
    }

    private PropertyDTO convertToDTO(Property property) {
        return new PropertyDTO(
                property.getId(),
                property.getTenantId(),
                property.getTitle(),
                property.getType(),
                property.getStatus(),
                property.getAddressStreet(),
                property.getAddressNumber(),
                property.getAddressComplement(),
                property.getAddressNeighborhood(),
                property.getAddressCity(),
                property.getAddressState(),
                property.getAddressZip(),
                property.getLatitude(),
                property.getLongitude(),
                property.getAreaTotalM2(),
                property.getAreaBuiltM2(),
                property.getBedrooms(),
                property.getBathrooms(),
                property.getParkingSpots(),
                property.getPrice(),
                property.getCondoFee(),
                property.getIptuAnnual(),
                property.getDescription(),
                property.getFeatures(),
                property.getRegistrationNumber()
        );
    }
}
