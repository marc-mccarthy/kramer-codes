output "bucket_url" {
  description = "URL of the S3 Bucket Website"
  value = "http://${aws_s3_bucket.website-bucket.bucket}.s3-website-${var.aws_region}.amazonaws.com"
}
