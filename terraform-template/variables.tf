## ------------------------------------------------------------------
## Variables without default values, should be defined at .tfvars.
## ------------------------------------------------------------------

variable "env" {
  description = "The environment for the resources"
  type        = string
}


## ------------------------------------------------------------------
## Variables with default values, you can override it at .tfvars.
## ------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-east-1"
}