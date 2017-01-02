
variable "user_name" { description = "The name of the user" }
variable "policy"    { description = "The policy to attach to the user" }
variable "user_path" { 
  description = "Path in which to create the user (default '/')"
  default     = "/"
}

resource "aws_iam_user" "user" {
  name = "${var.user_name}"
  path = "${var.user_path}"
}

resource "aws_iam_user_policy" "user_policy" {
  name   = "${var.user_name}-user-policy"
  user   = "${aws_iam_user.user.name}"
  policy = "${var.policy}"
}

output "user_arn" { value = "${aws_iam_user.user.arn}" }
