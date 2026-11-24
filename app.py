import requests


def health_check(url):
    response = requests.get(f"{url}/health", timeout=10)
    return response.status_code == 200
