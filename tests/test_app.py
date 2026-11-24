from unittest.mock import patch

from app import health_check


@patch("app.requests.get")
def test_health_ok(mock_get):
    mock_get.return_value.status_code = 200
    assert health_check("http://localhost:8080")


@patch("app.requests.get")
def test_health_error(mock_get):
    mock_get.return_value.status_code = 503
    assert not health_check("http://localhost:8080")
