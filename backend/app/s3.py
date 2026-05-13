import boto3
from app.config import settings


def get_s3_client():
    kwargs = {"region_name": settings.s3_region}
    if settings.s3_endpoint_url:
        kwargs["endpoint_url"] = settings.s3_endpoint_url
        kwargs["aws_access_key_id"] = settings.s3_access_key
        kwargs["aws_secret_access_key"] = settings.s3_secret_key
    return boto3.client("s3", **kwargs)


def build_public_url(key: str) -> str:
    base = settings.s3_public_base_url.rstrip("/")
    return f"{base}/{key}"
