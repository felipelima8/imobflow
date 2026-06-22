"""Tests for the Match scoring engine."""

from src.api.match_router import _calculate_match_score, _generate_reasons


class TestMatchScoring:
    """Test suite for customer-property match scoring."""

    def test_perfect_match_scores_high(self):
        profile = {
            "min_price": 300000,
            "max_price": 500000,
            "min_rooms": 2,
            "desired_type": "apartment",
            "preferred_neighborhoods": ["Centro"],
        }
        prop = {
            "id": "prop-1",
            "price": 400000,
            "bedrooms": 3,
            "type": "apartment",
            "address_neighborhood": "Centro",
        }
        score = _calculate_match_score(profile, prop)
        assert score >= 80, f"Perfect match should score >= 80, got {score}"

    def test_price_out_of_range_lowers_score(self):
        profile = {"min_price": 200000, "max_price": 300000, "min_rooms": 2}
        prop = {"id": "prop-2", "price": 500000, "bedrooms": 2}
        score = _calculate_match_score(profile, prop)
        assert score < 70, f"Out-of-range price should score < 70, got {score}"

    def test_reasons_generated_for_match(self):
        profile = {"min_price": 200000, "max_price": 400000, "min_rooms": 2}
        prop = {"id": "prop-3", "price": 300000, "bedrooms": 3}
        reasons = _generate_reasons(profile, prop, 85.0)
        assert len(reasons) > 0, "Should generate at least one reason"

    def test_empty_profile_returns_base_score(self):
        score = _calculate_match_score({}, {"id": "prop-4"})
        assert 40 <= score <= 60, f"Empty profile should return base score, got {score}"

    def test_score_clamped_to_0_100(self):
        profile = {"min_price": 0, "max_price": 0, "min_rooms": 100}
        prop = {"id": "prop-5", "price": 99999999, "bedrooms": 0}
        score = _calculate_match_score(profile, prop)
        assert 0 <= score <= 100, f"Score must be 0-100, got {score}"
