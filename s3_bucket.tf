# Create New S3 Bucket
resource "aws_s3_bucket" "tf_s3" {
	bucket = "lbtf-logs"
	force_destroy = true
	tags = {
		Name = "LB_Logs"
	}
}

resource "aws_s3_bucket_policy" "lb_logs" {
  bucket = aws_s3_bucket.tf_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowALBLogDelivery"
        Effect = "Allow"

        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.tf_s3.arn}/LBTF_Logs/*"
      }
    ]
  })
}

