# multi-key-lookup

This module is designed to retrieve 1-N values from a map of key-value pairs. We pass a CSV lists
of the map keys and a CSV list the map values into the module for processing. Additionally, a 3rd
CSV list is passed into the module representing the list of keys that we wish to retrieve values
for.


## Variables

> **keys**: A CSV List of keys to find values for, from the map
> <br/>**map_key_list**: A CSV List of the keys in the map
> <br/>**map_value_list**: A CSV List of the values in the map

## Outputs

> **values**: A CSV list of values corresponding to the keys that were looked up.


## Usage


I commonly use this to reference resources such as AWS Subnets and Security Groups by name, 
instead of by ID. This makes it easier to read and reference when reviewing the Terraform code. It
also allows for easier interpolation of resources.

Example:

Say I have a template that is isolated to build my VPC and Subnets in AWS, which outputs the
following. A list of `subnet_ids`, a list of `subnet_tag_names`, and my `vpc_id`.

    subnet_ids = subnet-12345678,subnet-87654321,subnet-abcdefab,subnet-fedcbafe
    subnet_tag_names = nonprod-application-az1,nonprod-application-az2,nonprod-database-az1,nonprod-database-az2
    vpc_id = vpc-12345678

Now I want to create an autoscaling group that launches instances into my application subnets,
which provides me with 2 Availability Zones for fault-tolerance. Trying to remember which subnet
id's to launch into can be cumbersome, but we can use the `multi_key_lookup` module to be able to
reference these by name. Furthermore, if we specify our VPC environment variable `vpc_env`, then
we can interpolate these names, this requiring no code changes between our nonprod and prod
environments.

    # Get our vpc remote state, giving us access to it's outputs
    data "terraform_remote_state" "vpc" {
      backend = "s3"
      config {
        region = "${var.region}"
        bucket = "${var.tf_state_bucket}"
        key    = "vpc_${var.vpc_env}.tfstate"
      }
    }
    
    # Use our module to extract the application subnet ids
    module "application_subnets" {
      source = "github.com/jyore/terraform_modules//multi_key_lookup"
    
      keys           = "${var.vpc_env}-application-az1,${var.vpc_env}-application-az2"
      map_key_list   = "${data.terraform_remote_state.vpc.subnet_tag_names}"
      map_value_list = "${data.terraform_remote_state.vpc.subnet_ids}"
    }
    
    
    # Declare our Autoscaling Group, using the subnets
    resource "aws_autoscaling_group" "autoscale_conf" {
      ...
      vpc_zone_identifier = ["${compact(split(",", module.application_subnets.values))}"]
      ...
    }

