
variable "keys"           { description = "CSV List of keys to retrieve values for" }
variable "map_key_list"   { description = "CSV List of keys in the map to perform lookup over" }
variable "map_value_list" { description = "CSV List of values in the map to perform lookup over" }


data "template_file" "values" {
  count = "${length(split(",", var.keys))}"
  template = "${value}"

  vars {
    value = "${element(split(",", var.map_value_list), index(split(",", var.map_key_list), element(split(",", var.keys), count.index)))}"
  }
}

output "values" { value = "${join(",", data.template_file.values.*.rendered)}" }
