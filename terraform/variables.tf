variable "vpc_id" {
  type        = string
  description = "The id of the specific VPC to retrieve."
}

variable "private_subnet_name" {
  type        = string
  description = "The name of the specific private subnet to retrieve."
}

variable "public_subnet_name" {
  type        = string
  description = "The name of the specific public subnet to retrieve."
}

variable "environment" {
  type        = string
  description = "The deployment environment state (eg. production, staging, tests)"
}

variable "name" {
  type        = string
  description = "The project name."
}

variable "key_name" {
  type        = string
  description = "The key name that should be used for the instance"
}

variable "gitlab_runner_url" {
  type        = string
  default     = "https://gitlab.com/"
  description = "Specify URL for the Runner setup"
}

variable "gitlab_runner_token" {
  type        = string
  description = "Specify token registration for Runner setup"
}

variable "gitlab_runner_instance_type" {
  type        = string
  default     = "m5a.large"
  description = "The type of instance to start the runner."
}

variable "gitlab_runner_concurrency" {
  type        = number
  default     = 4
  description = "Maximum concurrency for job requests."
}

variable "gitlab_runner_idle_count" {
  type        = number
  default     = 1
  description = "Number of machines, that need to be created and waiting in Idle state."
}

variable "request_spot_instance" {
  type        = bool
  default     = false
  description = "Specify if the Runner will create new machines using spot"
}

variable "spot_price" {
  type        = string
  default     = ""
  description = "The price to use for reserving spot instances"
}

variable "runner_root_disk_size" {
  type        = number
  default     = 60
  description = "The root disk size of the instance (in GB)"
}