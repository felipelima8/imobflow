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
            String tenantSlug = resolveTenantSlug(httpRequest);

            if (tenantSlug != null) {
                tenantRepository.findBySlug(tenantSlug).ifPresent(tenant -> {
                    TenantContext.setCurrentTenantId(tenant.getId());
                    log.debug("Tenant resolved: {} ({})", tenant.getSlug(), tenant.getId());
                });
            }

            chain.doFilter(request, response);
        } finally {
            TenantContext.clear();
        }
    }

    /**
     * Resolve tenant slug from subdomain or X-Tenant-ID header.
     * Priority: Header > Subdomain
     */
    private String resolveTenantSlug(HttpServletRequest request) {
        // 1. Check header (useful for development and API calls)
        String headerTenant = request.getHeader("X-Tenant-ID");
        if (headerTenant != null && !headerTenant.isBlank()) {
            return headerTenant;
        }

        // 2. Extract from subdomain (e.g., "acme.imobflow.com.br")
        String host = request.getServerName();
        if (host != null && host.contains(".")) {
            String subdomain = host.split("\\.")[0];
            if (!"localhost".equals(subdomain) && !"www".equals(subdomain) && !"api".equals(subdomain)) {
                return subdomain;
            }
        }

        return null;
    }
}
