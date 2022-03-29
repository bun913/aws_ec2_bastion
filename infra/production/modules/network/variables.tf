variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "vpc_cidr" {
  type        = string
  description = "Main VPC CidrBlock"
}
variable "db_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Private Subnets For RDS"
}
variable "public_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Public Subnets For NAT"
}
variable "private_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Private Subnets For Bastion"
}
variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}
