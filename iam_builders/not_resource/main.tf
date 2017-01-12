
variable "resources" { type = "list" }

data "template_file" "not_resource" {
  template = "${file("${path.module}/data/not_resource.json")}"

  vars {
    resources = "${jsonencode(var.resources)}"
  }
}

output "not_resource" { value = "${data.template_file.not_resource.rendered}" }
