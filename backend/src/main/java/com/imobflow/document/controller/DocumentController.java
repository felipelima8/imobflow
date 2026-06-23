package com.imobflow.document.controller;

import com.imobflow.document.dto.DocumentDTO;
import com.imobflow.document.service.DocumentService;
import com.imobflow.identity.TenantContext;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/documents")
public class DocumentController {

    private final DocumentService documentService;

    public DocumentController(DocumentService documentService) {
        this.documentService = documentService;
    }

    @PostMapping("/upload")
    public ResponseEntity<DocumentDTO> uploadDocument(
            @RequestParam("journeyId") UUID journeyId,
            @RequestParam("title") String title,
            @RequestParam("type") String type,
            @RequestParam("file") MultipartFile file) throws IOException {
        
        UUID tenantId = TenantContext.getCurrentTenantId();
        DocumentDTO dto = documentService.uploadDocument(journeyId, title, type, file, tenantId);
        return ResponseEntity.status(HttpStatus.CREATED).body(dto);
    }

    @GetMapping("/journey/{journeyId}")
    public ResponseEntity<List<DocumentDTO>> getJourneyDocuments(@PathVariable UUID journeyId) {
        return ResponseEntity.ok(documentService.getJourneyDocuments(journeyId));
    }

    @GetMapping("/{documentId}/download")
    public ResponseEntity<byte[]> downloadDocument(@PathVariable UUID documentId) throws IOException {
        com.imobflow.document.model.Document doc = documentService.getDocumentById(documentId);
        byte[] data = documentService.downloadDocument(documentId);

        String mimeType = doc.getMimeType();
        if (mimeType == null || mimeType.isEmpty()) {
            mimeType = "application/octet-stream";
        }

        return ResponseEntity.ok()
                .header(org.springframework.http.HttpHeaders.CONTENT_TYPE, mimeType)
                .header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + doc.getTitle() + "\"")
                .body(data);
    }
}
