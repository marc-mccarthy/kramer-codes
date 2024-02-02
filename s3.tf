resource "aws_s3_bucket" "website-bucket" {
  bucket        = "${var.aws_bucket_name}-1"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.website-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject", "s3:PutObject"],
        Effect    = "Allow",
        Resource  = "${aws_s3_bucket.website-bucket.arn}/*",
        Principal = "*"
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "website-bucket-acl-ownership" {
  bucket = aws_s3_bucket.website-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_website_configuration" "bucket-website-configuration" {
  bucket = aws_s3_bucket.website-bucket.id 
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website-public-block" {
  bucket = aws_s3_bucket.website-bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website-bucket.id
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.website-bucket.id
  key    = "styles.css"
  source = "./styles.css"
  content_type = "text/css"
}
