# vpn

Encapsulates creation of VPN Gateway, Customer Gateway, & VPN Connection resources

## Variables

> **vpc_id**: The ID of the VPC to setup the VPN Gateway for
> <br/>**vpn_name**: An identifying name value for the VPN
> <br/>**customer_bgp_asn**: The bgp asn to use for the Customer GW
> <br/>**customer_ip_address**: The IP Address to use for the Customer GW
> <br/>**customer_gw_name**: The name to give to the Customer GW
> <br/>**static_routes_only** ( _Default: false_ ): Use static routes exclusively or not


## Outputs

> **vpn_gateway_id**: The ID from the created VPN Gateway resource


## Usage

This example translates the example shown in the [Terraform docs](https://www.terraform.io/docs/providers/aws/r/vpn_connection.html).

    resource "aws_vpc" "vpc" {
      cidr_block = "10.0.0.0/16"
    }
    
    module "vpn" {
      source = "github.com/jyore/terraform_modules//vpn"
    
      vpc_id              = "${aws_vpc.vpc.id}"
      vpc_name            = "MyVPN"
      customer_bgp_asn    = 65000
      customer_ip_address = "172.0.0.1"
      customer_gw_name    = "MyCustomerGW"
      static_routes_only  = true
    }


We reduce the amout of code written from the example and have enforced naming the 
resources by using the module.
