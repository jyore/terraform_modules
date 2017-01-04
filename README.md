# terraform_modules

A collection of Terraform modules that I consistently use in projects.


# Usage

In order to use these modules, you can simply use the github style reference.

    module "use_module" {
      source = "github.com/jyore/terraform_modules//<module-name>"
      ...
    }


Example to reference the `subnet` module

    module "mysubnet" {
      source = "github.com/jyore/terraform_modules//subnet"
      ...
    }


# Modules

This section contains a list of modules and brief descriptions. Full documentation of each module
is found in the modules' respective subdirectory. 


* **[iam_role](https://github.com/jyore/terraform_modules/tree/master/iam_role)**: Encapsulates 
creation of an iam_role and policy attachments
* **[iam_user](https://github.com/jyore/terraform_modules/tree/master/iam_user)**: Encapsulates
creation of an iam_user and policy document
* **[multi_key_lookup](https://github.com/jyore/terraform_modules/tree/master/multi_key_lookup)**:
Utility module for extracting 1-N values from a key-value pair map
* **[natgw](https://github.com/jyore/terraform_modules/tree/master/natgw)**: Encapsulates creation
of NAT Gateways and EIPs for a list of given subnets
* **[subnet](https://github.com/jyore/terraform_modules/tree/master/subnet)**: Creates subnets
from a map of subnet names and associated CIDR blocks
* **[vpn](https://github.com/jyore/terraform_modules/tree/master/vpn)**: Encapsulates creation of
VPN Gateway, Customer Gateway, & VPN Connection resources
