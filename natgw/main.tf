
variable "nat_subnets" { type = "list" }

resource "aws_eip" "nat_gw_eip" {
  count = "${length(var.nat_subnets)}"
  vpc   = true
}

resource "aws_nat_gateway" "natgw" {
  count         = "${length(var.nat_subnets)}"
  allocation_id = "${element(aws_eip.nat_gw_eip.*.id, count.index)}"
  subnet_id     = "${element(var.nat_subnets, count.index)}"
}

output "natgw_ids"   { value = "${join(",", aws_nat_gateway.natgw.*.id)}" }
output "eni_ids"     { value = "${join(",", aws_nat_gateway.natgw.*.network_interface_id)}" }
