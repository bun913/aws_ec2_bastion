variable "region" {
  type    = string
  default = "ap-northeast-1"
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
variable "private_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Private Subnets For Bastion"
}
variable "public_subnets" {
  type = list(object({
    name = string
    az   = string
    cidr = string
  }))
  description = "Public Subnets For NAT"
}
variable "key_pair_name" {
  type        = string
  description = "あらかじめ作成したキーペアの名前"
  sensitive   = true
}
variable "tags" {
  type = map(string)
  default = {
    "Project"     = "fargate-bastion"
    "Environment" = "prd"
    "Terraform"   = "true"
  }
}
