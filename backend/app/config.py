from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "postgresql://postgres:postgres@localhost:5432/recipebox"

    # S3 / MinIO
    s3_bucket: str = "recipe-box"
    s3_region: str = "us-east-1"
    s3_endpoint_url: str = ""           # set for MinIO local, empty for real AWS
    s3_access_key: str = ""             # MinIO only; on AWS use IAM role
    s3_secret_key: str = ""
    s3_public_base_url: str = ""        # e.g. http://localhost:9000/recipe-box or https://bucket.s3.region.amazonaws.com

    class Config:
        env_file = ".env"


settings = Settings()
