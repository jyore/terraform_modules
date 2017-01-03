# iam_role

Encapsulates creating an iam role, with a main policy attachment, and 1-N additional policy attachments into a single module block.


## Variables

> **name**: The name of the Role
> <br/>**path** ( _Default: "/"_ ): The path in which to create the user
> <br/>**assume_role_policy**: The assume role policy for the role
> <br/>**policy_document**: The role's main policy document
> <br/>**additional_policy_arns** ( _Default: []_ ): A list of additional policy ARNs to attach


## Outputs

> **role_name**: The Name of the role
> <br/>**role_id**: The ID of the role
> <br/>**role_arn**: The ARN of the role


## Usage 

This example translates the resources defined in the following [Terraform docs](https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html)
with an example of attaching the builtin AWS ReadOnly policy, which would normally require a
resource defined in [this Terraform doc](https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html).

    module "test_role" {
      source = "github.com/jyore/terraform_modules//iam_role"
    
      name = "test_role"
      additional_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOF
      policy_document = <<EOF
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

While this example uses the Multiline output definition for the assume_role_policy and 
policy_document variables, I'd suggest putting those values in variables or separate files and
referencing them in practice. It improves the overall readability of the code.
