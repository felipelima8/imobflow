package com.imobflow.shared.dto;

import java.time.Instant;
import java.util.List;

/**
 * Standard error response for REST API.
 */
public record ErrorResponse(
        int status,
        String error,
        String message,
        String path,
        Instant timestamp,
        List<FieldError> fieldErrors
) {
    public ErrorResponse(int status, String error, String message, String path) {
        this(status, error, message, path, Instant.now(), List.of());
    }

    public record FieldError(String field, String message) {}
}
