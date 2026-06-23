package com.imobflow.document.service;

import com.imobflow.document.dto.DocumentDTO;
import com.imobflow.document.model.Document;
import com.imobflow.document.repository.DocumentRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.imobflow.journey.model.Journey;
import com.imobflow.journey.repository.JourneyRepository;

@Service
public class DocumentService {

    private final DocumentRepository documentRepository;
    private final JourneyRepository journeyRepository;
    private final S3Client s3Client;

    @Value("${s3.bucket:imobflow}")
    private String bucketName;

    public DocumentService(DocumentRepository documentRepository, JourneyRepository journeyRepository, S3Client s3Client) {
        this.documentRepository = documentRepository;
        this.journeyRepository = journeyRepository;
        this.s3Client = s3Client;
    }

    @Transactional
    public DocumentDTO uploadDocument(UUID journeyId, String title, String type, MultipartFile file, UUID tenantId) throws IOException {
        String filename = UUID.randomUUID() + "_" + file.getOriginalFilename();
        String s3Key = "tenant_" + tenantId + "/journey_" + journeyId + "/" + filename;
        String filePath = s3Key;

        // Try to upload to MinIO
        try {
            // Ensure bucket exists
            try {
                s3Client.createBucket(b -> b.bucket(bucketName));
            } catch (Exception e) {
                // Ignore if bucket already exists
            }

            s3Client.putObject(
                    PutObjectRequest.builder()
                            .bucket(bucketName)
                            .key(s3Key)
                            .contentType(file.getContentType())
                            .build(),
                    RequestBody.fromInputStream(file.getInputStream(), file.getSize())
            );
        } catch (Exception e) {
            System.err.println("MinIO upload failed, falling back to local file storage: " + e.getMessage());
            // Fallback: save to local directory 'uploads'
            Path uploadDir = Paths.get("uploads");
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }
            Path destination = uploadDir.resolve(filename);
            Files.copy(file.getInputStream(), destination, StandardCopyOption.REPLACE_EXISTING);
            filePath = destination.toAbsolutePath().toString();
        }

        Document document = new Document();
        document.setTenantId(tenantId);
        document.setJourneyId(journeyId);
        
        // Fetch details from Journey if available
        journeyRepository.findById(journeyId).ifPresent(journey -> {
            document.setCustomerId(journey.getCustomerId());
            document.setPropertyId(journey.getPropertyId());
        });

        document.setTitle(title);
        document.setType(type);
        document.setFilePath(filePath);
        document.setFileSize(file.getSize());
        document.setMimeType(file.getContentType());
        document.setStatus("APPROVED"); // Auto-approve uploaded file
        document.setUploadedBy(UUID.fromString("00000000-0000-0000-0000-000000000007")); // Default broker ID

        Document saved = documentRepository.save(document);
        return convertToDTO(saved);
    }

    @Transactional(readOnly = true)
    public List<DocumentDTO> getJourneyDocuments(UUID journeyId) {
        return documentRepository.findByJourneyId(journeyId)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private DocumentDTO convertToDTO(Document doc) {
        return new DocumentDTO(
                doc.getId(),
                doc.getTenantId(),
                doc.getJourneyId(),
                doc.getTitle(),
                doc.getType(),
                doc.getFilePath(),
                doc.getFileSize(),
                doc.getStatus(),
                doc.getUploadedBy(),
                doc.getCreatedAt(),
                doc.getUpdatedAt()
        );
    }
}
