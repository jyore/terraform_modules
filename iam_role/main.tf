
variable "name"               { description = "The name of the Role" }
variable "assume_role_policy" { description = "The assume role policy for the role" }
variable "policy_document"    { description = "The role's main policy document" }

variable "additional_policy_arns" {
  type = "list"
  description = " A list of additional policy ARNs to attach"
  default = []
}

variable "path" { 
  description = "The path in which to create the user"
  default = "/"
}


resource "aws_iam_role" "role" {
  name               = "${var.name}"
  path               = "${var.path}"
  assume_role_policy = "${var.assume_role_policy}"
}

resource "aws_iam_role_policy" "role_policy" {
  name   = "${var.name}_Policy"
  role   = "${aws_iam_role.role.id}"
  policy = "${var.policy_document}"
}

resource "aws_iam_role_policy_attachment" "arn_attachment" {
  count      = "${length(var.additional_policy_arns)}"
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${element(var.additional_policy_arns, count.index)}"
}


output "role_name" { value = "${aws_iam_role.role.name}" }
output "role_id"   { value = "${aws_iam_role.role.id}" }
output "role_arn"  { value = "${aws_iam_role.role.arn}" }
