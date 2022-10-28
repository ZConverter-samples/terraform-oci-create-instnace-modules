locals {
  instance_type_split = split(".", "${var.instance_type_name}")
  ssh_authorized_keys = var.OS != "Windows" ? var.ssh_public_key != null ? var.ssh_public_key : var.ssh_public_key_file_path != null ? base64encode(file(var.ssh_public_key_file_path)) : null : null
  user_data_file_path = var.user_data != null ? base64encode(var.user_data) : var.user_data_file_path != null ? base64encode(file(var.user_data_file_path)) : null
  volume_device = formatlist("/dev/oracleoci/oraclevd%s", [
    "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ]
  )
  protocol = {
    "all" : "all",
    "icmp" : "1",
    "tcp" : "6",
    "udp" : "17",
    "icmpv6" : "58"
  }

  ingress_security_list = var.security_list != null ? [
    for data in var.security_list :
    data
    if data.direction == "ingress"
  ] : null

  egress_security_list = var.security_list != null ? [
    for data in var.security_list :
    data
    if data.direction == "egress"
  ] : null
}

variable "region" {
  type    = string
  default = null
}

variable "vm_name" {
  type    = string
  default = ""
}

variable "subnet_ocid" {
  type = string
}

variable "security_list" {
  type = list(object({
    direction        = optional(string)
    ethertype        = optional(string)
    protocol         = optional(string)
    port_range_min   = optional(string)
    port_range_max   = optional(string)
    remote_ip_prefix = optional(string)
    type             = optional(string)
    code             = optional(string)
  }))
  default = null
}

variable "compartment_ocid" {
  type    = string
  default = null
}

variable "OS" {
  type    = string
  default = null
}

variable "OS_version" {
  type    = string
  default = null
}

variable "custom_image_name" {
  type    = string
  default = null
}

variable "boot_volume_size_in_gbs" {
  type    = number
  default = 50
}

variable "instance_type_name" {
  type    = string
  default = null
}

variable "instance_cpus" {
  type    = number
  default = 1
}

variable "instance_memory_in_gbs" {
  type    = number
  default = 16
}

variable "ssh_public_key" {
  type    = string
  default = null
}

variable "ssh_public_key_file_path" {
  type    = string
  default = null
}

variable "user_data_file_path" {
  type    = string
  default = null
}

variable "user_data" {
  type = string
  default = null
}

variable "additional_volumes" {
  type    = list(number)
  default = []
}