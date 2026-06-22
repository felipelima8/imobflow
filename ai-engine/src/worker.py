"""
RabbitMQ Worker — Consumes AI requests and publishes results.
Mirrors PlantaAI worker pattern.
"""

import json
import logging

import pika
import structlog

from src.config.settings import get_settings
from src.api.match_router import _calculate_match_score, _generate_reasons

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
        profile = message.get("profile", {})
        prop = message.get("property", {})
        score = _calculate_match_score(profile, prop)
        reasons = _generate_reasons(profile, prop, score)
        return {
            "score": score,
            "reasons": reasons,
            "property_id": prop.get("id"),
        }
    elif request_type == "ocr":
        doc_type = message.get("document_type", "RG")
        s3_key = message.get("s3_key", "")
        return {
            "extracted_data": {
                "name": "Maria Silva Santos",
                "cpf": "123.456.789-00",
                "rg": "12.345.678-9",
                "monthly_income": 8500.00 if doc_type == "INCOME_PROOF" else None,
                "document_type": doc_type,
                "s3_key": s3_key
            },
            "confidence": 0.95
        }
    elif request_type == "chat":
        return {
            "reply": "Olá! Sou o assistente da ImobFlow. Posso te ajudar com dúvidas sobre a jornada de compra.",
            "suggested_actions": ["Simular Financiamento", "Consultar Status", "Enviar Documento"]
        }
    elif request_type == "analysis":
        return {
            "prediction": 88.5,
            "message": "Alta probabilidade de fechamento baseada no perfil financeiro e histórico de propostas."
        }
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
