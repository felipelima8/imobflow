"""Document API — OCR extraction and document analysis."""

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class OcrRequest(BaseModel):
    s3_key: str
    document_type: str  # RG, CPF, INCOME_PROOF, PROPERTY_DEED


class OcrResponse(BaseModel):
    extracted_data: dict
    confidence: float
    document_type: str


@router.post("/ocr", response_model=OcrResponse)
async def extract_document(request: OcrRequest) -> OcrResponse:
    """Extract structured data from a document image via OCR + LLM."""
    # TODO: Implement Tesseract OCR + Claude structured extraction
    return OcrResponse(
        extracted_data={"status": "not_implemented"},
        confidence=0.0,
        document_type=request.document_type,
    )


class RiskAnalysisRequest(BaseModel):
    document_texts: list[str]
    property_registration: str | None = None


class RiskAnalysisResponse(BaseModel):
    risk_level: str  # LOW, MEDIUM, HIGH, CRITICAL
    score: float
    issues: list[str]
    recommendations: list[str]


@router.post("/risk-analysis", response_model=RiskAnalysisResponse)
async def analyze_risk(request: RiskAnalysisRequest) -> RiskAnalysisResponse:
    """Analyze legal risk based on property certificates and documents."""
    # TODO: Implement Claude Opus legal analysis
    return RiskAnalysisResponse(
        risk_level="LOW",
        score=0.0,
        issues=[],
        recommendations=["Análise não implementada ainda"],
    )
