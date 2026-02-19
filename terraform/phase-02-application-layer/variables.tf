variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "zerotrust-webapp"
}

# -----------------------------------------------
# DATA SOURCES - pull outputs from Phase 1
# -----------------------------------------------
variable "vpc_id" {
  description = "VPC ID from Phase 1"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs from Phase 1"
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private app subnet IDs from Phase 1"
  type        = list(string)
}

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs from Phase 1"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

# -----------------------------------------------
# EC2 / ASG
# -----------------------------------------------
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 1
}

# -----------------------------------------------
# RDS AURORA
# -----------------------------------------------
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "zerotrust_db"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}