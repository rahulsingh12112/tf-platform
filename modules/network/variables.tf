variable "name" {
  type = string
}

variable "cidr" {
  type = string
  validation {
    condition = can(cidrhost(var.cidr, 0))
    error_message = "cidr valid hona chahiye, jaise 10.10.0.0/16"
  }
}