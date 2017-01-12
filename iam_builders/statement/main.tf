
# Required fields
# -----------------------------------------------------------
variable "sid"        { }
variable "effect"     { }
variable "actions"    { type = "list" }
variable "resources"  { type = "list" }



# Non Required Fields (i.e. use other modules to build json)
# -----------------------------------------------------------
variable "principal"      { default = "" }
variable "not_principal" { default = "" }
variable "not_action"    { default = "" }
variable "not_resource"  { default = "" }
variable "conditions"    { default = "" }



# Statement Template
# -----------------------------------------------------------
data "template_file" "statement" {
  template = "${file("${path.module}/data/statement.json")}"

  vars {
    sid           = "${var.sid}"
    effect        = "${var.effect}"
    actions       = "${jsonencode(var.actions)}"
    resources     = "${jsonencode(var.resources)}"
    principal     = "${var.principal}"
    not_principal = "${var.not_principal}"
    not_action    = "${var.not_action}"
    not_resource  = "${var.not_resource}"
    conditions    = "${var.conditions}"
  }
}


# Output
# -----------------------------------------------------------
output "statement" { value = "${data.template_file.statement.rendered}" }
