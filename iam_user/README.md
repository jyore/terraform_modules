# iam_user

Encapsulates creating a user with a policy for convienience.


## Variables

> **user_name**: The name of the user
> <br/>**user_path** ( _Default: "/"_ ): The path in which to create the user
> <br/>**policy**: The policy document to attach to the user


## Outputs

> **user_arn**: The ARN of the created user


## Usage

Instead of needing multiple resource blocks to create a user, we can simply use a single module
block. Translating the example from the [Terraform Docs](https://www.terraform.io/docs/providers/aws/r/iam_user.html), we get the following:

    module "lb_user" {
      source = "github.com/jyore/terraform_modules//iam_user"
    
      user_name = "loadbalancer"
      user_path = "/system/"
      policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "ec2:Describe*"
          ],
          "Effect": "Allow",
          "Resource": "*"
        }
      ]
    }
    EOF
    }


Nothing too special here, but saves some time and keystrokes.

