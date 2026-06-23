package com.imobflow.document.model;

import com.imobflow.shared.model.BaseEntity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Entity
@Table(name = "documents")
@Getter
@Setter
public class Document extends BaseEntity {

    @Column(name = "journey_id")
    private UUID journeyId;

    @Column(name = "customer_id")
    private UUID customerId;

    @Column(name = "property_id")
    private UUID propertyId;

    @Column(name = "name", nullable = false)
    private String title;

    @Column(nullable = false, length = 50)
    private String type;

    @Column(name = "s3_key", nullable = false, length = 500)
    private String filePath;

    @Column(name = "file_size_bytes")
    private Long fileSize;

    @Column(name = "mime_type", length = 100)
    private String mimeType;

    @Column(length = 30)
    private String status = "PENDING";

    @Column(name = "uploaded_by")
    private UUID uploadedBy;
}
