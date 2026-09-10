# storage/s3.tf — REFERENCE ONLY
# See ../README.md — mirrors ../main.tf.

resource "aws_s3_bucket" "artifacts" {
  bucket = var.bucket_name

  tags = {
    Name        = "${var.environment}-artifacts"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}
