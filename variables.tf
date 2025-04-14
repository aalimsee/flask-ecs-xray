



variable "aws_region" {
  default = "us-east-1"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag" {
  description = "ECR image tag (e.g., github.sha)"
  type        = string
}
