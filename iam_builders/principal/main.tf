
variable "provider"   { }
variable "identities" { type = "list" }

data "template_file" "principal" {
  template = "${file("${path.module}/data/principal.json")}"

  vars {
    provider   = "${var.provider}"
    identities = "${jsonencode(var.identities)}"
  }
}

output "principal" { value = "${data.template_file.principal.rendered}" }
