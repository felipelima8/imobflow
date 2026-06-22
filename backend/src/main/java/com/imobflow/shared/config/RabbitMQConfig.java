package com.imobflow.shared.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * RabbitMQ exchange, queues, and bindings for async communication with AI Engine.
 */
@Configuration
public class RabbitMQConfig {

    public static final String EXCHANGE = "imobflow.exchange";

    // Match queues
    public static final String MATCH_REQUEST_QUEUE = "match.request";
    public static final String MATCH_RESULT_QUEUE = "match.result";

    // OCR queues
    public static final String OCR_REQUEST_QUEUE = "ocr.request";
    public static final String OCR_RESULT_QUEUE = "ocr.result";

    // Chat queues
    public static final String CHAT_REQUEST_QUEUE = "chat.request";
    public static final String CHAT_RESPONSE_QUEUE = "chat.response";

    // Notification queue
    public static final String NOTIFICATION_QUEUE = "notification.send";

    // Journey event queue
    public static final String JOURNEY_EVENT_QUEUE = "journey.event";

    @Bean
    public TopicExchange imobflowExchange() {
        return new TopicExchange(EXCHANGE);
    }

    @Bean
    public Queue matchRequestQueue() { return QueueBuilder.durable(MATCH_REQUEST_QUEUE).build(); }

    @Bean
    public Queue matchResultQueue() { return QueueBuilder.durable(MATCH_RESULT_QUEUE).build(); }

    @Bean
    public Queue ocrRequestQueue() { return QueueBuilder.durable(OCR_REQUEST_QUEUE).build(); }

    @Bean
    public Queue ocrResultQueue() { return QueueBuilder.durable(OCR_RESULT_QUEUE).build(); }

    @Bean
    public Queue chatRequestQueue() { return QueueBuilder.durable(CHAT_REQUEST_QUEUE).build(); }

    @Bean
    public Queue chatResponseQueue() { return QueueBuilder.durable(CHAT_RESPONSE_QUEUE).build(); }

    @Bean
    public Queue notificationQueue() { return QueueBuilder.durable(NOTIFICATION_QUEUE).build(); }

    @Bean
    public Queue journeyEventQueue() { return QueueBuilder.durable(JOURNEY_EVENT_QUEUE).build(); }

    @Bean
    public Binding matchRequestBinding() {
        return BindingBuilder.bind(matchRequestQueue()).to(imobflowExchange()).with(MATCH_REQUEST_QUEUE);
    }

    @Bean
    public Binding matchResultBinding() {
        return BindingBuilder.bind(matchResultQueue()).to(imobflowExchange()).with(MATCH_RESULT_QUEUE);
    }

    @Bean
    public Binding ocrRequestBinding() {
        return BindingBuilder.bind(ocrRequestQueue()).to(imobflowExchange()).with(OCR_REQUEST_QUEUE);
    }

    @Bean
    public Binding ocrResultBinding() {
        return BindingBuilder.bind(ocrResultQueue()).to(imobflowExchange()).with(OCR_RESULT_QUEUE);
    }

    @Bean
    public Binding notificationBinding() {
        return BindingBuilder.bind(notificationQueue()).to(imobflowExchange()).with(NOTIFICATION_QUEUE);
    }

    @Bean
    public Binding journeyEventBinding() {
        return BindingBuilder.bind(journeyEventQueue()).to(imobflowExchange()).with(JOURNEY_EVENT_QUEUE);
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
