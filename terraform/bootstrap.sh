#!/usr/bin/env bash
# Run this ONCE before terraform init to create the S3 bucket and DynamoDB
# table that will store Terraform state and provide locking.
#
# Usage:
#   chmod +x bootstrap.sh
#   ./bootstrap.sh                        # uses defaults (eu-west-3, obs-lab)
#   ./bootstrap.sh eu-west-1 my-project   # custom region and project
#
# After this script, run:
#   terraform init -backend-config=backend.hcf

set -euo pipefail

REGION="${1:-eu-west-3}"
PROJECT="${2:-obs-lab}"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET="${PROJECT}-tfstate-${ACCOUNT_ID}"
TABLE="${PROJECT}-tfstate-lock"
KEY="dev/terraform.tfstate"

echo "==> Account : ${ACCOUNT_ID}"
echo "==> Bucket  : ${BUCKET}"
echo "==> Table   : ${TABLE}"
echo ""

# --- S3 bucket ---
echo "==> Creating S3 bucket..."
aws s3api create-bucket \
  --bucket "${BUCKET}" \
  --region "${REGION}" \
  --create-bucket-configuration LocationConstraint="${REGION}"

# Versioning: lets you recover a previous state if something goes wrong
aws s3api put-bucket-versioning \
  --bucket "${BUCKET}" \
  --versioning-configuration Status=Enabled

# Encryption at rest
aws s3api put-bucket-encryption \
  --bucket "${BUCKET}" \
  --server-side-encryption-configuration \
    '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Block all public access
aws s3api put-public-access-block \
  --bucket "${BUCKET}" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# --- DynamoDB table ---
echo "==> Creating DynamoDB table..."
aws dynamodb create-table \
  --table-name "${TABLE}" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${REGION}"

# --- Write backend.hcf ---
cat > backend.hcf <<EOF
bucket         = "${BUCKET}"
key            = "${KEY}"
region         = "${REGION}"
dynamodb_table = "${TABLE}"
encrypt        = true
EOF

echo ""
echo "==> Done. backend.hcf written."
echo ""
echo "Next step:"
echo "  terraform init -backend-config=backend.hcf"
