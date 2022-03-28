variable "prefix" {
  type        = string
  description = "Default Prefix of Resource Name"
}
variable "vpc_id" {
  type = string
}
variable "private_subnet_id" {
  type = string
}
variable "tags" {
  type = object({
    Environment = string
    Project     = string
    Terraform   = string
  })
}
