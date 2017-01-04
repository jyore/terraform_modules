
# Template files
# --------------------------------------------------------------------
data "template_file" "bucket_policy" {
  template = "${file("${path.module}/templates/bucket_policy.json")}"
  
  vars {
    bucket_name = "${var.s3_bucket_name}"
  }
}

data "template_file" "sns_sqs_policy" {
  template = "${file("${path.module}/templates/sns_sqs_policy.json")}"

  vars {
    region     = "${var.region}"
    account_id = "${var.account_id}"
    queue_name = "${var.queue_name}"
    topic_name = "${var.topic_name}"
  }
}



# Backing Resources
# --------------------------------------------------------------------
resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.s3_bucket_name}"
  policy        = "${data.template_file.bucket_policy.rendered}"
  force_destroy = true
}

resource "aws_sns_topic" "topic" {
  name = "${var.topic_name}"
}

resource "aws_sqs_queue" "queue" {
  name   = "${var.queue_name}"
  policy = "${data.template_file.sns_sqs_policy.rendered}"
}

resource "aws_sns_topic_subscription" "cloudtrail_sqs_subscription" {
  topic_arn = "${aws_sns_topic.topic.arn}"
  endpoint  = "${aws_sqs_queue.queue.arn}"
  protocol  = "sqs"
}



# Cloudtrail
# --------------------------------------------------------------------
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.trail_name}"
  s3_bucket_name                = "${aws_s3_bucket.bucket.bucket}"
  s3_key_prefix                 = "${var.s3_key_prefix}"
  cloud_watch_logs_role_arn     = "${var.cloud_watch_logs_role_arn}"
  cloud_watch_logs_group_arn    = "${var.cloud_watch_logs_group_arn}"
  enable_logging                = "${var.enable_logging}"
  include_global_service_events = "${var.include_global_service_events}"
  is_multi_region_trail         = "${var.is_multi_region_trail}"
  sns_topic_name                = "${aws_sns_topic.topic.name}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  kms_key_id                    = "${var.kms_key_id}"
}



# Outputs
# --------------------------------------------------------------------
output "id"          { value = "${aws_cloudtrail.cloudtrail.id}" }
output "home_region" { value = "${aws_cloudtrail.cloudtrail.home_region}" }
output "arn"         { value = "${aws_cloudtrail.cloudtrail.arn}" }
