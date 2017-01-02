

variable "vpc_id"  { }
variable "region"  { }
variable "zones"   { type = "list" }
variable "subnets" { type = "map"}

resource "aws_subnet" "subnets" {
  count = "${length(var.subnets)}"

  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(values(var.subnets), count.index)}"
  availability_zone = "${var.region}${element(var.zones, count.index)}"

  tags {
    Name = "${element(keys(var.subnets), count.index)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "subnet_ids" { value = "${join(",", aws_subnet.subnets.*.id)}" }
output "tag_names"  { value = "${join(",", aws_subnet.subnets.*.tags.Name)}" }
