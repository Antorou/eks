# ---------------------------------------------------------------------------
# The trust policy is the heart of IRSA.
#
# It says: "only allow AssumeRoleWithWebIdentity when the request comes from
# our specific OIDC provider AND the sub (subject) claim matches exactly
# system:serviceaccount:<namespace>:<service-account-name>".
#
# That sub claim is set by Kubernetes — it can't be forged by a pod running
# in a different namespace or using a different service account name.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.app_namespace}:${var.app_service_account}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# The permission policy: what can this role actually do?
# Scoped to one specific bucket — least privilege.
data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${var.s3_bucket_arn}/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [var.s3_bucket_arn]
  }
}

resource "aws_iam_role" "app" {
  name               = "${var.name_prefix}-app"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy" "s3_access" {
  name   = "s3-access"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.s3_access.json
}
