variable "version"    { default = "2012-10-17" }
variable "statements" { type = "list" }

data "template_file" "policy" {
  template = "${file("${path.module}/data/policy.json")}"

  vars {
    vers       = "${var.version}"
    statements = "[${join(",",var.statements)}]"
  }
}

output "policy" { value = "${replace(data.template_file.policy.rendered, "/\\n/","")}" }
