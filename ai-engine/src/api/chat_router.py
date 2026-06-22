"""Chat API — Real estate chatbot powered by LLM."""

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class ChatMessage(BaseModel):
    role: str  # user, assistant
    content: str


class ChatRequest(BaseModel):
    messages: list[ChatMessage]
    context: dict | None = None  # Customer profile, current journey, etc.


class ChatResponse(BaseModel):
    reply: str
    suggested_actions: list[str]


@router.post("/message", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    """Send a message to the real estate chatbot."""
    # TODO: Implement RAG with property/journey context + Claude
    last_message = request.messages[-1].content if request.messages else ""
    return ChatResponse(
        reply=f"Recebi sua mensagem: '{last_message}'. O chatbot ainda está em desenvolvimento.",
        suggested_actions=["Ver imóveis disponíveis", "Simular financiamento", "Falar com corretor"],
    )
