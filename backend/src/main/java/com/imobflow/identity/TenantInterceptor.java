package com.imobflow.identity;

import jakarta.persistence.EntityManager;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.hibernate.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Aspect that enables the Hibernate tenant filter before any repository operation.
 * Ensures all queries are automatically scoped to the current tenant.
 * Dual-layer isolation: Hibernate @Filter (app) + PostgreSQL RLS (DB).
 */
@Aspect
@Component
public class TenantInterceptor {

    private static final Logger log = LoggerFactory.getLogger(TenantInterceptor.class);
    private final EntityManager entityManager;

    public TenantInterceptor(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    @Before("execution(* org.springframework.data.repository.Repository+.*(..))")
    public void enableTenantFilter() {
        UUID tenantId = TenantContext.getCurrentTenantId();
        Session session = entityManager.unwrap(Session.class);

        if (tenantId != null) {
            // Enable Hibernate filter (Application-level)
            session.enableFilter("tenantFilter")
                    .setParameter("tenantId", tenantId);

            // Set Postgres session variable (Database-level RLS)
            session.doWork(connection -> {
                try (var statement = connection.prepareStatement(
                        "SELECT set_config('app.current_tenant', ?, false)")) {
                    statement.setString(1, tenantId.toString());
                    statement.execute();
                }
            });

            log.debug("Tenant isolation enabled for session: {}", tenantId);
        } else {
            session.disableFilter("tenantFilter");

            session.doWork(connection -> {
                try (var statement = connection.prepareStatement(
                        "SELECT set_config('app.current_tenant', '', false)")) {
                    statement.execute();
                }
            });

            log.debug("Tenant isolation disabled (context is null)");
        }
    }
}
