"""ImobFlow AI Engine — FastAPI application."""

import logging
import os

import structlog
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.api.match_router import router as match_router
from src.api.document_router import router as document_router
from src.api.chat_router import router as chat_router
from src.api.analysis_router import router as analysis_router


def configure_logging():
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


configure_logging()
logger = structlog.get_logger(__name__)

app = FastAPI(
    title="ImobFlow AI Engine",
    version="0.1.0",
    description="AI services: Match, OCR, Chatbot, Analysis",
)

ALLOWED_ORIGINS = os.getenv(
    "CORS_ORIGINS", "http://localhost:3000,http://localhost:8080"
).split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

app.include_router(match_router, prefix="/api/v1/match", tags=["Match"])
app.include_router(document_router, prefix="/api/v1/documents", tags=["Documents"])
app.include_router(chat_router, prefix="/api/v1/chat", tags=["Chat"])
app.include_router(analysis_router, prefix="/api/v1/analysis", tags=["Analysis"])


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "healthy", "service": "ai-engine", "version": "0.1.0"}


@app.get("/")
async def root() -> dict[str, str]:
    return {"message": "ImobFlow AI Engine is running"}
