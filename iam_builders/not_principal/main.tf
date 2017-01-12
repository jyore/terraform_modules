
variable "provider"   { }
variable "identities" { type = "list" }

data "template_file" "not_principal" {
  template = "${file("${path.module}/data/not_principal.json")}"

  vars {
    provider   = "${var.provider}"
    identities = "${jsonencode(var.identities)}"
  }
}

output "not_principal" { value = "${data.template_file.not_principal.rendered}" }
