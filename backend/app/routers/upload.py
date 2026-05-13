import ipaddress
import socket
import uuid
from io import BytesIO
from urllib.parse import urlparse

import httpx
from fastapi import APIRouter, UploadFile, File, HTTPException
from pydantic import BaseModel
from app.s3 import get_s3_client, build_public_url
from app.config import settings

router = APIRouter(prefix="/api/upload", tags=["upload"])

MAX_UPLOAD_BYTES = 10 * 1024 * 1024  # 10 MB

ALLOWED_MIME_TYPES = {
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
    "image/avif",
}

MIME_TO_EXT = {
    "image/jpeg": "jpg",
    "image/png": "png",
    "image/gif": "gif",
    "image/webp": "webp",
    "image/avif": "avif",
}


def _assert_safe_url(url: str) -> None:
    """Block SSRF: reject non-http(s) schemes and private/loopback IPs."""
    parsed = urlparse(url)
    if parsed.scheme not in ("http", "https"):
        raise HTTPException(status_code=400, detail="Only http/https URLs are allowed")
    hostname = parsed.hostname
    if not hostname:
        raise HTTPException(status_code=400, detail="Invalid URL")
    try:
        ip = ipaddress.ip_address(socket.gethostbyname(hostname))
    except (socket.gaierror, ValueError):
        raise HTTPException(status_code=400, detail="Cannot resolve hostname")
    if (
        ip.is_private
        or ip.is_loopback
        or ip.is_link_local
        or ip.is_reserved
        or ip.is_multicast
    ):
        raise HTTPException(status_code=400, detail="URL points to a disallowed address")


@router.post("/file")
async def upload_file(file: UploadFile = File(...)):
    content_type = (file.content_type or "").split(";")[0].strip()
    if content_type not in ALLOWED_MIME_TYPES:
        raise HTTPException(status_code=400, detail="Only image files are accepted (jpeg, png, gif, webp, avif)")

    contents = await file.read()
    if len(contents) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=413, detail="File too large (max 10 MB)")

    ext = MIME_TO_EXT[content_type]
    key = f"recipes/{uuid.uuid4()}.{ext}"
    s3 = get_s3_client()
    s3.upload_fileobj(
        BytesIO(contents),
        settings.s3_bucket,
        key,
        ExtraArgs={"ContentType": content_type},
    )
    return {"url": build_public_url(key)}


class UrlPayload(BaseModel):
    url: str


@router.post("/url")
async def upload_from_url(payload: UrlPayload):
    _assert_safe_url(payload.url)

    async with httpx.AsyncClient(follow_redirects=False, timeout=10) as client:
        resp = await client.get(payload.url)

    if resp.status_code != 200:
        raise HTTPException(status_code=400, detail="Failed to fetch image from URL")

    if len(resp.content) > MAX_UPLOAD_BYTES:
        raise HTTPException(status_code=413, detail="Remote image too large (max 10 MB)")

    content_type = resp.headers.get("content-type", "").split(";")[0].strip()
    if content_type not in ALLOWED_MIME_TYPES:
        raise HTTPException(status_code=400, detail="URL does not point to a supported image type")

    ext = MIME_TO_EXT[content_type]
    key = f"recipes/{uuid.uuid4()}.{ext}"
    s3 = get_s3_client()
    s3.put_object(
        Bucket=settings.s3_bucket,
        Key=key,
        Body=resp.content,
        ContentType=content_type,
    )
    return {"url": build_public_url(key)}
