
#Variables for overall use
variable "environment" {
  description = "Environment fo the current infrastructure"
  type        = string
}

variable "project" {
  description = "The project's name"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

#VPC and networking
variable "vpc_cidr" {
  type        = string
  description = "VPC Cidr Block"
  default     = "10.0.0.0/16"
}

variable "subnets_web" {

  type        = list(string)
  description = "A list of subnets with their CIDR blocks."
  default     = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
}

variable "subnets_app" {
  type        = list(string)
  description = "A list of subnets with their CIDR blocks."
  default     = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "subnets_db" {
  type        = list(string)
  description = "A list of subnets with their CIDR blocks."
  default     = ["10.0.40.0/24", "10.0.41.0/24", "10.0.42.0/24"]
}

#AutoScaling & Launch Configuraitons
variable "instance_type" {
  type        = string
  description = "Instance type to be used under the ASG launch template"
  default     = "t2.micro"
}

variable "key_name" {
  default     = "test_infra"
  description = "Name of AWS key pair"
}

variable "asg_min_size" {
  type        = number
  description = "minimum number of Instances to be scaled by the ASG"
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "maximum number of Instances to be scaled by the ASG"
  default     = 2
}

variable "asg_desired_capacity" {
  type        = number
  description = "desired number of Instances to be scaled by the ASG"
  default     = 1
}

variable "health_check_grace_period" {
  type        = number
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
}