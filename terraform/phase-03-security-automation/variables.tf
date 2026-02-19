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
# FROM PHASE 1 & 2
# -----------------------------------------------
variable "vpc_id" {
  description = "VPC ID from Phase 1"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name from Phase 2"
  type        = string
}

variable "alb_arn" {
  description = "ALB ARN from Phase 2"
  type        = string
}

# -----------------------------------------------
# NOTIFICATION
# -----------------------------------------------
variable "alert_email" {
  description = "Email address for security alerts"
  type        = string
}