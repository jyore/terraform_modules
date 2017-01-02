# terraform_modules

A collection of Terraform modules that I consistently use in projects.


# Table of Contents

* [Usage](#Usage)
* [Modules](#Modules)
  * [multi_key_lookup](#multi_key_lookup)
  * [subnet](#subnet)


# Usage

In order to use these modules, you can simply use the github style reference.

Example to reference the `subnet` module
```
module "mysubnet" {
  source = "github.com/jyore/terraform_modules//subnet"
  ...
}
```


# Modules

This section contains a list of modules and how to use them


## multi_key_lookup

This module is designed to retrieve 1-N values from a map of key-value pairs. We pass a CSV lists
of the map keys and a CSV list the map values into the module for processing. Additionally, a 3rd
CSV list is passed into the module representing the list of keys that we wish to retrieve values
for.


### Variables

> **keys**: A CSV List of keys to find values for, from the map
> <br/>**map_key_list**: A CSV List of the keys in the map
> <br/>**map_value_list**: A CSV List of the values in the map

### Outputs

> **values**: A CSV list of values corresponding to the keys that were looked up.


### Usage


I commonly use this to reference resources such as AWS Subnets and Security Groups by name, 
instead of by ID. This makes it easier to read and reference when reviewing the Terraform code. It
also allows for easier interpolation of resources.

Example:

Say I have a template that is isolated to build my VPC and Subnets in AWS, which outputs the
following. A list of `subnet_ids`, a list of `subnet_tag_names`, and my `vpc_id`.
```
subnet_ids = subnet-12345678,subnet-87654321,subnet-abcdefab,subnet-fedcbafe
subnet_tag_names = nonprod-application-az1,nonprod-application-az2,nonprod-database-az1,nonprod-database-az2
vpc_id = vpc-12345678
```

Now I want to create an autoscaling group that launches instances into my application subnets,
which provides me with 2 Availability Zones for fault-tolerance. Trying to remember which subnet
id's to launch into can be cumbersome, but we can use the `multi_key_lookup` module to be able to
reference these by name. Furthermore, if we specify our VPC environment variable `vpc_env`, then
we can interpolate these names, this requiring no code changes between our nonprod and prod
environments.

```
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

```


## subnet

This module is a convience module for declaring AWS Subnets with a single key-value map variable.
This generates output lists that are ready for the [multi_key_lookup](#multi_key_lookup) module.


### Variables

> **vpc_id**: The VPC ID to launch the subnets under
> <br/>**region**: The AWS Region the VPC resides under
> <br/>**zones**: A list of Availability Zones to map the subnets to (i.e. ["a","c"])
> <br/>**subnets**: A map with keys representing subnet names and values representing CIDR blocks


Note that the subnets will cycle through which availability zone they are applied to. So if your
`zones` list contains 2 AZs and your `subnets` map contains 4 subnets, then the 1st and 3rd subnet
will be in the 1st AZ and the 2nd and 4th subnet will be in the 2nd AZ

### Outputs

> **subnet_ids**: A CSV list of created subnet IDs
> <br/>**tag_names**: A CSV list of created subnet names


### Usage

Let's say we have a VPC with a CIDR block of 10.0.0.0/16 and we wish to launch 2 Application 
subnets and 2 Database subnets into Availability Zones A and C in the us-east-1 region. We can do
that simply with the following code.


```
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
```

Now we will have all of our subnets created for our vpc. We can easily add/update/remove subnets 
by modifying variables. We can also manage additional environments through variables instead and
keep the same template code.
