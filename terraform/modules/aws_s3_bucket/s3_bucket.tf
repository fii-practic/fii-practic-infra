resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket
  acl           = var.acl
  force_destroy = var.force_destroy
  request_payer = var.request_payer

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "trail_lifecycle_rule"
    enabled = true

    tags = {
      "rule"      = "trail_lifecycle_rule"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 120
    }
  }
}
