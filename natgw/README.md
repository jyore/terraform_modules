# natgw
This module is another convienience module that will build EIP and NAT Gateway resources for all
subnets in the provided list.


## Variables

> **nat_subnets**: A list of subnet_ids to create NAT Gateways for


## Outputs

> **natgw_ids**: A CSV list of all the created NAT Gateway IDs
> <br/>**eni_ids**: A CSV list of all the created ENI IDs


## Usage

This is another module that is handy to use in combination with the [multi_key_lookup](https://github.com/jyore/terraform_modules/tree/master/multi_key_lookup) module.

Given we have created the following via the [subnet](https://github.com/jyore/terraform_modules/tree/master/subnet) module

    subnet_ids = subnet-12345678,subnet-87654321,subnet-abcdefab,subnet-fedcbafe
    subnet_tag_names = application-nonprod-nat-az1,application-dev-no-nat-az1,application-nonprod-nat-az2,application-dev-no-nat-az2


We might do the following

    module "nat_subnets" {
      source = "github.com/jyore/terraform_modules//multi_key_lookup"
    
      keys           = "application-${var.vpc_env}-nat-az1,application-${var.vpc_env}-nat-az2"
      map_key_list   = "${module.subnets.subnet_tag_names}"
      map_value_list = "${module.subnets.subnet_ids}"
    }

    module "natgw" {
      source      = "github.com/jyore/terraform_modules//natgw"
      nat_subnets = ["${split(",", module.nat_subnets.values)}"]
    }


We would then get have NAT Gateways configured for the 2 subnets from our list (subnet-12345678 & 
subnet-abcdefab)

