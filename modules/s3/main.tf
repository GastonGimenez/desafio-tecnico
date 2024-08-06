resource "aws_s3_bucket" "new_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "new_acl" {
    bucket = aws_s3_bucket.new_bucket.id
    acl = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.new_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {

  bucket = aws_s3_bucket.new_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  count = var.enable_lifecycle ? 1 : 0

  bucket = aws_s3_bucket.new_bucket.id

  rule {
    id = var.lifecycle_ruleID
    status = "Enabled"

    expiration {
      days = var.lifecycle_days
    }

    transition {
      days = var.lifecycle_transition_days
      storage_class = var.lifecycle_storageclass
    }
  }
}