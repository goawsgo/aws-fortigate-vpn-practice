###################
# vpn
###################
module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  vpc_id              = module.vpc.vpc_id
  vpn_gateway_id      = module.vpc.vgw_id
  customer_gateway_id = module.vpc.cgw_ids[0]

  vpc_subnet_route_table_count = 3
  vpc_subnet_route_table_ids   = module.vpc.private_route_table_ids
}

###################
# vpc
###################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"
  name    = "aws-vpn-vpc"
  cidr    = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_vpn_gateway      = true
  map_public_ip_on_launch = true
  customer_gateways = {
    Taipei = {
      bgp_asn    = 65220
      ip_address = aws_eip.fortigate_ec2.public_ip
    },
  }
  depends_on = [aws_eip.fortigate_ec2]
}

module "vpc-fortigate" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"
  name    = "fortigate-vpc"
  cidr    = "10.10.0.0/16"

  azs                     = ["us-east-1a", "us-east-1b"]
  private_subnets         = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets          = ["10.10.101.0/24", "10.10.102.0/24"]
  map_public_ip_on_launch = true
}

resource "aws_route" "fortigate" {
  route_table_id         = module.vpc-fortigate.public_route_table_ids[0]
  destination_cidr_block = "10.0.0.0/16"
  network_interface_id   = aws_instance.fortigate.primary_network_interface_id
}

resource "aws_route" "aws-vpn" {
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = "10.10.0.0/16"
  gateway_id             = module.vpc.vgw_id
}