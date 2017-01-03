# subnet
This module is a convience module for declaring AWS Subnets with a single key-value map variable.
This generates output lists that are ready for the [multi_key_lookup](https://github.com/jyore/terraform_modules/tree/master/multi_key_lookup) module.


## Variables

> **vpc_id**: The VPC ID to launch the subnets under
> <br/>**region**: The AWS Region the VPC resides under
> <br/>**zones**: A list of Availability Zones to map the subnets to (i.e. ["a","c"])
> <br/>**subnets**: A map with keys representing subnet names and values representing CIDR blocks


Note that the subnets will cycle through which availability zone they are applied to. So if your
`zones` list contains 2 AZs and your `subnets` map contains 4 subnets, then the 1st and 3rd subnet
will be in the 1st AZ and the 2nd and 4th subnet will be in the 2nd AZ

## Outputs

> **subnet_ids**: A CSV list of created subnet IDs
> <br/>**tag_names**: A CSV list of created subnet names


## Usage

Let's say we have a VPC with a CIDR block of 10.0.0.0/16 and we wish to launch 2 Application 
subnets and 2 Database subnets into Availability Zones A and C in the us-east-1 region. We can do
that simply with the following code.


    variable "vpc_env" { default = "nonprod" }
    variable "region"  { default = "us-east-1" }
    
    variable "availability_zones" {
      type = "list"
      default = ["a", "c"]
    }
    
    variable "nonprod-subnets" {
      type = "map"
      default = {
        nonprod-database-az1    = "10.0.1.0/24"
        nonprod-database-az2    = "10.0.2.0/24"
        nonprod-application-az1 = "10.0.11.0/24"
        nonprod-application-az2 = "10.0.12.0/24"
      }
    }
    
    resource "aws_vpc" "vpc" {
      cidr_block = "10.0.0.0/16"
    
      tags {
        Name       = "my-${var.vpc_env}-vpc"
        Environment = "${var.vpc_env}"
      }
    }
    
    module "subnets" {
      source = "github.com/jyore/terraform_modules//subnet"
    
      vpc_id  = "${aws_vpc.vpc.id}"
      region  = "${var.region}"
      zones   = "${var.availability_zones}"
      subnets = "${var.${vpc_env}-subnets}"
    }


Now we will have all of our subnets created for our vpc. We can easily add/update/remove subnets 
by modifying variables. We can also manage additional environments through variables instead and
keep the same template code.
