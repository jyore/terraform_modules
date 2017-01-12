
variable "exception" { }

data "template_file" "not_action" {
  template = "${file("${path.module}/data/not_action.json")}"

  vars {
    exception = "${var.exception}"
  }
}

output "not_action" { value = "${data.template_file.not_action.rendered}" }
