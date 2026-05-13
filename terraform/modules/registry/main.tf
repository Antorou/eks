locals {
  repos = ["backend", "frontend"]
}

resource "aws_ecr_repository" "this" {
  for_each = toset(local.repos)

  name                 = "${var.project_name}/${each.key}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
