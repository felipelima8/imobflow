package com.imobflow.shared.service;

import com.imobflow.shared.config.RabbitMQConfig;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class AiIntegrationService {

    private static final Logger log = LoggerFactory.getLogger(AiIntegrationService.class);

    private final RabbitTemplate rabbitTemplate;

    public AiIntegrationService(RabbitTemplate rabbitTemplate) {
        this.rabbitTemplate = rabbitTemplate;
    }

    /**
     * Publishes a match score request payload to the AI match queue.
     */
    public void requestMatch(UUID requestId, Map<String, Object> customerProfile, Map<String, Object> propertyData) {
        log.info("Sending Match request to RabbitMQ for RequestID: {}", requestId);
        
        Map<String, Object> payload = Map.of(
            "request_id", requestId.toString(),
            "type", "match",
            "profile", customerProfile,
            "property", propertyData
        );

        rabbitTemplate.convertAndSend(
            RabbitMQConfig.EXCHANGE,
            RabbitMQConfig.MATCH_REQUEST_QUEUE,
            payload
        );
    }

    /**
     * Publishes a document OCR request payload.
     */
    public void requestOcr(UUID requestId, String s3Key, String documentType) {
        log.info("Sending OCR request to RabbitMQ for RequestID: {}", requestId);

        Map<String, Object> payload = Map.of(
            "request_id", requestId.toString(),
            "type", "ocr",
            "s3_key", s3Key,
            "document_type", documentType
        );

        rabbitTemplate.convertAndSend(
            RabbitMQConfig.EXCHANGE,
            RabbitMQConfig.OCR_REQUEST_QUEUE,
            payload
        );
    }

    /**
     * Listener consuming results from match calculations.
     */
    @RabbitListener(queues = RabbitMQConfig.MATCH_RESULT_QUEUE)
    public void onMatchResult(Map<String, Object> resultPayload) {
        String requestId = (String) resultPayload.get("request_id");
        String status = (String) resultPayload.get("status");
        
        log.info("Received Match result for RequestID: {} with status: {}", requestId, status);
        if ("success".equalsIgnoreCase(status)) {
            Map<String, Object> data = (Map<String, Object>) resultPayload.get("data");
            Double score = (Double) data.get("score");
            log.info("Calculated Match score is: {}", score);
            // TODO: Update Customer-Property Match table or trigger alert in production DB
        } else {
            String error = (String) resultPayload.get("error");
            log.error("AI Match error for RequestID: {}: {}", requestId, error);
        }
    }

    /**
     * Listener consuming results from document OCR tasks.
     */
    @RabbitListener(queues = RabbitMQConfig.OCR_RESULT_QUEUE)
    public void onOcrResult(Map<String, Object> resultPayload) {
        String requestId = (String) resultPayload.get("request_id");
        String status = (String) resultPayload.get("status");

        log.info("Received OCR result for RequestID: {} with status: {}", requestId, status);
        if ("success".equalsIgnoreCase(status)) {
            Map<String, Object> data = (Map<String, Object>) resultPayload.get("data");
            log.info("OCR successfully extracted data: {}", data);
            // TODO: Persist extracted payload in DB 'documents' metadata column
        } else {
            String error = (String) resultPayload.get("error");
            log.error("AI OCR error for RequestID: {}: {}", requestId, error);
        }
    }
}
