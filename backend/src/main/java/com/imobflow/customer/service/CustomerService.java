package com.imobflow.customer.service;

import com.imobflow.customer.dto.CreateCustomerDTO;
import com.imobflow.customer.dto.CustomerDTO;
import com.imobflow.customer.model.Customer;
import com.imobflow.customer.model.CustomerStatus;
import com.imobflow.customer.repository.CustomerRepository;
import com.imobflow.shared.exception.ResourceNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
public class CustomerService {

    private final CustomerRepository customerRepository;

    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @Transactional(readOnly = true)
    public Page<CustomerDTO> getCustomers(UUID brokerId, Pageable pageable) {
        Page<Customer> customers;
        if (brokerId != null) {
            customers = customerRepository.findByAssignedBroker(brokerId, pageable);
        } else {
            customers = customerRepository.findAll(pageable);
        }
        return customers.map(this::convertToDTO);
    }

    @Transactional(readOnly = true)
    public CustomerDTO getCustomerById(UUID id) {
        return customerRepository.findById(id)
                .map(this::convertToDTO)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + id));
    }

    @Transactional
    public CustomerDTO createCustomer(CreateCustomerDTO dto, UUID tenantId) {
        Customer customer = new Customer();
        customer.setTenantId(tenantId);
        customer.setName(dto.name());
        customer.setEmail(dto.email());
        customer.setPhone(dto.phone());
        customer.setCpf(dto.cpf());
        customer.setRg(dto.rg());
        customer.setMaritalStatus(dto.maritalStatus());
        customer.setMonthlyIncome(dto.monthlyIncome());
        customer.setFgtsBalance(dto.fgtsBalance());
        customer.setProfile(dto.profile() != null ? dto.profile() : "{}");
        customer.setStatus(CustomerStatus.LEAD);
        customer.setSource(dto.source());
        customer.setAssignedBroker(dto.assignedBroker());

        Customer saved = customerRepository.save(customer);
        return convertToDTO(saved);
    }

    @Transactional
    public CustomerDTO updateCustomer(UUID id, CreateCustomerDTO dto) {
        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found with id: " + id));

        customer.setName(dto.name());
        customer.setEmail(dto.email());
        customer.setPhone(dto.phone());
        customer.setCpf(dto.cpf());
        customer.setRg(dto.rg());
        customer.setMaritalStatus(dto.maritalStatus());
        customer.setMonthlyIncome(dto.monthlyIncome());
        customer.setFgtsBalance(dto.fgtsBalance());
        if (dto.profile() != null) {
            customer.setProfile(dto.profile());
        }
        customer.setSource(dto.source());
        customer.setAssignedBroker(dto.assignedBroker());

        Customer updated = customerRepository.save(customer);
        return convertToDTO(updated);
    }

    @Transactional
    public void deleteCustomer(UUID id) {
        if (!customerRepository.existsById(id)) {
            throw new ResourceNotFoundException("Customer not found with id: " + id);
        }
        customerRepository.deleteById(id);
    }

    private CustomerDTO convertToDTO(Customer customer) {
        return new CustomerDTO(
                customer.getId(),
                customer.getTenantId(),
                customer.getName(),
                customer.getEmail(),
                customer.getPhone(),
                customer.getCpf(),
                customer.getRg(),
                customer.getMaritalStatus(),
                customer.getMonthlyIncome(),
                customer.getFgtsBalance(),
                customer.getProfile(),
                customer.getStatus(),
                customer.getSource(),
                customer.getAssignedBroker()
        );
    }
}
