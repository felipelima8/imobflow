package com.imobflow.shared.dto;

import java.util.List;

/**
 * Standard paginated response wrapper.
 */
public record PaginatedResponse<T>(
        List<T> content,
        int page,
        int size,
        long totalElements,
        int totalPages,
        boolean hasNext
) {}
