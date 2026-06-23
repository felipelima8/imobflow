package com.imobflow.identity;

import com.imobflow.identity.model.Tenant;
import com.imobflow.identity.repository.TenantRepository;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.UUID;

/**
 * Servlet filter that resolves the current tenant from the request subdomain or header.
 * Sets the tenant ID in TenantContext for downstream usage.
 */
@Component
@Order(1)
public class TenantFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(TenantFilter.class);
    private final TenantRepository tenantRepository;

    public TenantFilter(TenantRepository tenantRepository) {
        this.tenantRepository = tenantRepository;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            
            // 1. Check X-Tenant-ID header
            String headerTenant = httpRequest.getHeader("X-Tenant-ID");
            if (headerTenant != null && !headerTenant.isBlank()) {
                try {
                    // Try parsing as UUID directly
                    UUID tenantId = UUID.fromString(headerTenant);
                    TenantContext.setCurrentTenantId(tenantId);
                    log.debug("Tenant resolved from header UUID: {}", tenantId);
                } catch (IllegalArgumentException e) {
                    // If not a UUID, treat it as a slug
                    tenantRepository.findBySlug(headerTenant).ifPresent(tenant -> {
                        TenantContext.setCurrentTenantId(tenant.getId());
                        log.debug("Tenant resolved from header slug: {} ({})", tenant.getSlug(), tenant.getId());
                    });
                }
            } else {
                // 2. Try resolving from subdomain slug
                String host = httpRequest.getServerName();
                if (host != null && host.contains(".")) {
                    String subdomain = host.split("\\.")[0];
                    if (!"localhost".equals(subdomain) && !"www".equals(subdomain) && !"api".equals(subdomain)) {
                        tenantRepository.findBySlug(subdomain).ifPresent(tenant -> {
                            TenantContext.setCurrentTenantId(tenant.getId());
                            log.debug("Tenant resolved from subdomain: {} ({})", tenant.getSlug(), tenant.getId());
                        });
                    }
                }
            }

            chain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }
}
