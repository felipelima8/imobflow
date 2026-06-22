"""
RabbitMQ Worker — Consumes AI requests and publishes results.
Mirrors PlantaAI worker pattern.
"""

import json
import logging

import pika
import structlog

from src.config.settings import get_settings

if not structlog.is_configured():
    structlog.configure(
        processors=[
            structlog.stdlib.add_log_level,
            structlog.stdlib.add_logger_name,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.JSONRenderer(),
        ],
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
        wrapper_class=structlog.stdlib.BoundLogger,
        cache_logger_on_first_use=True,
    )
    logging.basicConfig(format="%(message)s", level=logging.INFO)

logger = structlog.get_logger(__name__)

QUEUES = {
    "match.request": "match.result",
    "ocr.request": "ocr.result",
    "chat.request": "chat.response",
    "analysis.request": "analysis.result",
}


def on_message(channel, method, properties, body):
    """Handle incoming AI request from any queue."""
    message = None
    log = logger.new()
    try:
        message = json.loads(body)
        request_type = message.get("type", "unknown")
        request_id = message.get("request_id")

        log = log.bind(request_type=request_type, request_id=request_id)
        log.info("Received AI request")

        # Route to appropriate handler
        result = _handle_request(request_type, message)

        result_queue = QUEUES.get(method.routing_key, "match.result")
        result_message = {
            "request_id": request_id,
            "type": request_type,
            "status": "success",
            "data": result,
        }

        channel.basic_publish(
            exchange="imobflow.exchange",
            routing_key=result_queue,
            body=json.dumps(result_message),
            properties=pika.BasicProperties(content_type="application/json"),
        )

        channel.basic_ack(delivery_tag=method.delivery_tag)
        log.info("AI request processed successfully")

    except Exception as e:
        log.error("AI request failed", error=str(e), exc_info=True)

        error_message = {
            "request_id": message.get("request_id") if message else None,
            "status": "error",
            "error": str(e),
        }
        channel.basic_publish(
            exchange="imobflow.exchange",
            routing_key="match.result",
            body=json.dumps(error_message),
            properties=pika.BasicProperties(content_type="application/json"),
        )
        channel.basic_ack(delivery_tag=method.delivery_tag)


def _handle_request(request_type: str, message: dict) -> dict:
    """Route request to appropriate handler."""
    if request_type == "match":
        return {"matches": [], "message": "Match processing not yet implemented"}
    elif request_type == "ocr":
        return {"extracted_data": {}, "message": "OCR processing not yet implemented"}
    elif request_type == "chat":
        return {"reply": "Chat not yet implemented", "suggested_actions": []}
    elif request_type == "analysis":
        return {"prediction": 0.0, "message": "Analysis not yet implemented"}
    else:
        return {"message": f"Unknown request type: {request_type}"}


def main():
    settings = get_settings()
    logger.info("Connecting to RabbitMQ", host=settings.rabbitmq_host, port=settings.rabbitmq_port)

    credentials = pika.PlainCredentials(settings.rabbitmq_user, settings.rabbitmq_password)
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=settings.rabbitmq_host,
            port=settings.rabbitmq_port,
            credentials=credentials,
        )
    )
    channel = connection.channel()

    for queue in QUEUES:
        channel.queue_declare(queue=queue, durable=True)
    for result_queue in QUEUES.values():
        channel.queue_declare(queue=result_queue, durable=True)

    channel.basic_qos(prefetch_count=1)
    for queue in QUEUES:
        channel.basic_consume(queue=queue, on_message_callback=on_message)

    logger.info("AI Engine worker started. Waiting for messages...")
    try:
        channel.start_consuming()
    except KeyboardInterrupt:
        logger.info("Worker shutting down...")
        channel.stop_consuming()
    connection.close()


if __name__ == "__main__":
    main()
