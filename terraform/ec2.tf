###################
# ec2
###################

# AMI
data "aws_ami" "AmazonLinux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

# get kms aws/ebs
data "aws_kms_alias" "ebs_key" {
  name = "alias/aws/ebs"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.custom_name_prefix}-key" # Create key to AWS!!
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" { # Create key.pem to your computer!!
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./${var.custom_name_prefix}-key.pem"
  }
}

# ping test
module "fortigate-vpc-ping-test" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "fortigate-vpc-ping-test"
  ami                    = data.aws_ami.AmazonLinux2.id # change
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [module.test-sg.security_group_id]
  subnet_id              = module.vpc-fortigate.public_subnets[0] # change
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.id
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 8
      encrypted   = true
    }
  ]
}

module "aws-vpn-vpc-ping-test" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "aws-vpn-vpc-ping-test"
  ami                    = data.aws_ami.AmazonLinux2.id # change
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [module.test-sg2.security_group_id]
  subnet_id              = module.vpc.public_subnets[0] # change
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.id
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 8
      encrypted   = true
    }
  ]
}

resource "aws_instance" "fortigate" {
  subnet_id              = module.vpc-fortigate.public_subnets[0]
  ami                    = "ami-059d36a8887155edb"
  instance_type          = "t2.small"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [module.fortigate-sg.security_group_id]
  source_dest_check      = false
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = data.aws_kms_alias.ebs_key.target_key_arn
    volume_type           = "gp2"
    volume_size           = 2
    tags = {
      Name = "fortigate"
    }
  }

  tags = {
    Name = "fortigate"
  }
}


###################
# sg
###################
module "fortigate-sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.13.1"
  name                = "sgrp-all"
  description         = "sgrp-all"
  use_name_prefix     = false
  vpc_id              = module.vpc-fortigate.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]
}

module "test-sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.13.1"
  name                = "test-all"
  description         = "test-all"
  use_name_prefix     = false
  vpc_id              = module.vpc-fortigate.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]
}
module "test-sg2" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.13.1"
  name                = "test-all"
  description         = "test-all"
  use_name_prefix     = false
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]
}

###################
# eip
###################
resource "aws_eip" "fortigate_ec2" {
  instance = aws_instance.fortigate.id
  vpc      = true

  tags = {
    "Name" = "fortigate-ec2-eip"
  }
}

