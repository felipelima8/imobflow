"""Match API — Intelligent customer-property matching."""

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class MatchRequest(BaseModel):
    customer_profile: dict
    properties: list[dict]
    top_k: int = 5


class MatchResult(BaseModel):
    property_id: str
    score: float
    reasons: list[str]


class MatchResponse(BaseModel):
    matches: list[MatchResult]


@router.post("/score", response_model=MatchResponse)
async def score_matches(request: MatchRequest) -> MatchResponse:
    """Score and rank properties against a customer profile."""
    results = []
    for prop in request.properties:
        score = _calculate_match_score(request.customer_profile, prop)
        reasons = _generate_reasons(request.customer_profile, prop, score)
        results.append(MatchResult(
            property_id=prop.get("id", ""),
            score=score,
            reasons=reasons,
        ))

    results.sort(key=lambda x: x.score, reverse=True)
    return MatchResponse(matches=results[:request.top_k])


def _calculate_match_score(profile: dict, property_data: dict) -> float:
    """Calculate a 0-100 match score based on profile vs property attributes."""
    score = 50.0  # Base score
    weights = {
        "price": 30,
        "bedrooms": 20,
        "location": 25,
        "type": 15,
        "area": 10,
    }

    # Price match
    min_price = profile.get("min_price", 0)
    max_price = profile.get("max_price", float("inf"))
    prop_price = property_data.get("price", 0)
    if min_price <= prop_price <= max_price:
        score += weights["price"]
    elif prop_price > 0:
        deviation = min(abs(prop_price - min_price), abs(prop_price - max_price))
        penalty = min(deviation / max(max_price, 1) * weights["price"], weights["price"])
        score -= penalty

    # Bedrooms match
    desired_rooms = profile.get("min_rooms", 0)
    actual_rooms = property_data.get("bedrooms", 0)
    if actual_rooms >= desired_rooms:
        score += weights["bedrooms"]
    elif actual_rooms > 0:
        score += weights["bedrooms"] * (actual_rooms / max(desired_rooms, 1))

    # Location match
    desired_neighborhoods = [n.lower() for n in profile.get("preferred_neighborhoods", [])]
    prop_neighborhood = property_data.get("address_neighborhood", "").lower()
    if prop_neighborhood and prop_neighborhood in desired_neighborhoods:
        score += weights["location"]

    # Type match
    desired_type = profile.get("desired_type", "").lower()
    prop_type = property_data.get("type", "").lower()
    if desired_type and desired_type == prop_type:
        score += weights["type"]

    return max(0, min(100, round(score, 1)))


def _generate_reasons(profile: dict, prop: dict, score: float) -> list[str]:
    """Generate human-readable reasons for the match score."""
    reasons = []
    if score >= 80:
        reasons.append("Imóvel altamente compatível com seu perfil")
    if prop.get("bedrooms", 0) >= profile.get("min_rooms", 0):
        reasons.append(f"{prop.get('bedrooms')} quartos atendem sua preferência")
    min_p = profile.get("min_price", 0)
    max_p = profile.get("max_price", float("inf"))
    if min_p <= prop.get("price", 0) <= max_p:
        reasons.append("Dentro da faixa de preço desejada")
    return reasons
