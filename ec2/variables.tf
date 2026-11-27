variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "owner" {
  type    = string
  default = "rahul"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "Lab allows only t3.micro or t3.small."
  }
}

variable "root_volume_gb" {
  type    = number
  default = 8
}
