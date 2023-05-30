variable "custom_name_prefix" {
  description = "Custom name prefix"
  type        = string
  default     = null
}

## AWS Credential
variable "aws_profile" {
  description = "AWS Credential"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
