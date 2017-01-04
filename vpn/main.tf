
variable "vpc_id"              { description = "The ID for the VPC" }
variable "vpn_name"            { description = "A name for your VPN connection" }
variable "customer_bgp_asn"    { description = "The Customer GW bgp asn" }
variable "customer_ip_address" { description = "The Customer GW IP address" }
variable "customer_gw_name"    { description = "A name for the Customer GW resource" }

variable "static_routes_only" { 
  default     = false
  description = "Use static routes exclusively or not"
}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.vpn_name}"
  }
}

resource "aws_customer_gateway" "customer_gw" {
  bgp_asn    = "${var.customber_bgp_asn}"
  ip_address = "${var.customer_ip_address}"
  type       = "ipsec.1"

  tags {
    Name = "${var.customer_gw_name}"
  }
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = "${aws_vpn_gateway.vpn_gateway.id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gw.id}"
  type                = "ipsec.1"
  static_routes_only  = "${var.static_routes_only}"

  tags {
    Name = "${var.vpn_name}"
  }
}

output "vpn_gateway_id" { value = "${aws_vpn_gateway.vpn_gateway.id}" }
