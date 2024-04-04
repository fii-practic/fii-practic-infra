resource "aws_cloudtrail" "trail" {
  name                          = "${var.account}-audit-trail"
  s3_bucket_name                = module.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  depends_on                    = [aws_s3_bucket_policy.trail_bucket_policy]
}

module "trail_bucket" {
  source = "../s3_bucket"
  bucket = "${var.account}-audit-trail"
  acl    = "private"

  tags = {
    Name    = "var.account-audit-trail"
    Creator = "Managed by Terraform"
  }

}

resource "aws_s3_bucket_policy" "trail_bucket_policy" {
  bucket = module.trail_bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${module.trail_bucket.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${module.trail_bucket.arn}/AWSLogs/${var.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

