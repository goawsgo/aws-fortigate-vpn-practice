<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.0.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-vpn-vpc-ping-test"></a> [aws-vpn-vpc-ping-test](#module\_aws-vpn-vpc-ping-test) | terraform-aws-modules/ec2-instance/aws | ~> 3.0 |
| <a name="module_fortigate-sg"></a> [fortigate-sg](#module\_fortigate-sg) | terraform-aws-modules/security-group/aws | 4.13.1 |
| <a name="module_fortigate-vpc-ping-test"></a> [fortigate-vpc-ping-test](#module\_fortigate-vpc-ping-test) | terraform-aws-modules/ec2-instance/aws | ~> 3.0 |
| <a name="module_test-sg"></a> [test-sg](#module\_test-sg) | terraform-aws-modules/security-group/aws | 4.13.1 |
| <a name="module_test-sg2"></a> [test-sg2](#module\_test-sg2) | terraform-aws-modules/security-group/aws | 4.13.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 4.0.2 |
| <a name="module_vpc-fortigate"></a> [vpc-fortigate](#module\_vpc-fortigate) | terraform-aws-modules/vpc/aws | 4.0.2 |
| <a name="module_vpn_gateway"></a> [vpn\_gateway](#module\_vpn\_gateway) | terraform-aws-modules/vpn-gateway/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.fortigate_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.ssm_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route.aws-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.fortigate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.AmazonLinux2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.AmazonSSMManagedInstanceCore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_alias.ebs_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS Credential | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_custom_name_prefix"></a> [custom\_name\_prefix](#input\_custom\_name\_prefix) | Custom name prefix | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->