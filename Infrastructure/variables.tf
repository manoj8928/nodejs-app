variable "app_name" {
  type        = string
  description = "Name of the Application"
  default     = "demo"
}

variable "region" {
  default     = "eu-central-1"
}

variable "container_memory" {}

variable "container_cpu" {}

variable "image" {}

variable "access_logs_config" {
  description = "The name of the S3 bucket to store access logs."
  type        = list(map(string))
  default     = []
}

variable "alb_type" {
  description = "Type of ALB: 'public' or 'internal'. True means internal elb, false means public elb."
  type        = bool
  default     = false
}

variable "cidr" {
  description = "(Required) CIDR used to create VPC (e.g. 10.10.10.10/16)"
  type        = string
  default    = "10.140.0.0/16"
}

variable "private_subnets" {
  description = "(Optional) A list of private subnets inside the VPC. If not present, will be calculated from CIDR."
  type        = list(string)
  default     = ["10.140.21.0/24", "10.140.22.0/24", "10.140.23.0/24"]
}

variable "public_subnets" {
  description = "(Optional) A list of public subnets inside the VPC. If not present, will be calculated from CIDR."
  type        = list(string)
  default     = ["10.140.11.0/24", "10.140.12.0/24", "10.140.13.0/24"]
}