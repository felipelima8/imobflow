"""Analysis API — Predictive analytics for deal closing and pricing."""

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class DealPredictionRequest(BaseModel):
    journey_data: dict  # Timeline events, days in each stage, docs submitted
    customer_data: dict  # Income, FGTS, engagement level
    property_data: dict  # Price, type, location


class DealPredictionResponse(BaseModel):
    close_probability: float  # 0-100%
    estimated_days_to_close: int | None
    key_factors: list[str]
    recommended_actions: list[str]


@router.post("/deal-prediction", response_model=DealPredictionResponse)
async def predict_deal(request: DealPredictionRequest) -> DealPredictionResponse:
    """Predict probability of closing a deal based on journey data."""
    # TODO: Implement XGBoost model trained on historical data
    return DealPredictionResponse(
        close_probability=0.0,
        estimated_days_to_close=None,
        key_factors=["Modelo ainda não treinado"],
        recommended_actions=["Coletar mais dados históricos para treinar o modelo"],
    )


class PriceEstimateRequest(BaseModel):
    address_city: str
    address_neighborhood: str
    property_type: str
    area_m2: float
    bedrooms: int
    bathrooms: int
    parking_spots: int


class PriceEstimateResponse(BaseModel):
    estimated_price: float
    price_range_low: float
    price_range_high: float
    price_per_m2: float
    confidence: float
    comparables_count: int


@router.post("/price-estimate", response_model=PriceEstimateResponse)
async def estimate_price(request: PriceEstimateRequest) -> PriceEstimateResponse:
    """Estimate market price for a property (AVM)."""
    # TODO: Implement ML model with comparable sales data
    return PriceEstimateResponse(
        estimated_price=0.0,
        price_range_low=0.0,
        price_range_high=0.0,
        price_per_m2=0.0,
        confidence=0.0,
        comparables_count=0,
    )
