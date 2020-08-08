variable "key_name" {}

variable "vpc_id" {}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "alb_target_group_arn" {}

variable "user_data_filename" {}

variable "asg_name" {}

variable "min_size" {}

variable "max_size" {}

variable "owner" {}

variable "environment" {}