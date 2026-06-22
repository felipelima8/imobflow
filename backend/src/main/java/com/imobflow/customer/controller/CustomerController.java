package com.imobflow.customer.controller;

import com.imobflow.customer.dto.CreateCustomerDTO;
import com.imobflow.customer.dto.CustomerDTO;
import com.imobflow.customer.service.CustomerService;
import com.imobflow.identity.TenantContext;
import com.imobflow.shared.dto.PaginatedResponse;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/customers")
public class CustomerController {

    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    @GetMapping
    public ResponseEntity<PaginatedResponse<CustomerDTO>> getCustomers(
            @RequestParam(required = false) UUID brokerId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<CustomerDTO> customersPage = customerService.getCustomers(brokerId, PageRequest.of(page, size));
        var response = new PaginatedResponse<>(
                customersPage.getContent(),
                customersPage.getNumber(),
                customersPage.getSize(),
                customersPage.getTotalElements(),
                customersPage.getTotalPages(),
                customersPage.hasNext()
        );
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CustomerDTO> getCustomerById(@PathVariable UUID id) {
        return ResponseEntity.ok(customerService.getCustomerById(id));
    }

    @PostMapping
    public ResponseEntity<CustomerDTO> createCustomer(@Valid @RequestBody CreateCustomerDTO dto) {
        UUID tenantId = TenantContext.getCurrentTenantId();
        if (tenantId == null) {
            // Default tenant for requests without subdomain (e.g. testing or local non-isolated calls)
            tenantId = UUID.fromString("00000000-0000-0000-0000-000000000001");
        }
        CustomerDTO created = customerService.createCustomer(dto, tenantId);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<CustomerDTO> updateCustomer(
            @PathVariable UUID id,
            @Valid @RequestBody CreateCustomerDTO dto) {
        return ResponseEntity.ok(customerService.updateCustomer(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCustomer(@PathVariable UUID id) {
        customerService.deleteCustomer(id);
        return ResponseEntity.noContent().build();
    }
}
