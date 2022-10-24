locals {
  instance_type_split = split(".", "${var.instance_type_name}")
  ssh_authorized_keys = var.OS != "Windows" ? var.ssh_public_key != null ? var.ssh_public_key : var.ssh_public_key_file_path != null ? base64encode(file(var.ssh_public_key_file_path)) : null : null
  user_data_file_path = var.user_data_file_path != null ? file(var.user_data_file_path) : null
  volume_device       = formatlist("/dev/oracleoci/oraclevd%s", ["b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"])
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

variable "additional_volumes" {
  type    = list(number)
  default = []
}

locals {
  user_name = var.OS == "Windows" ? try(data.oci_core_instance_credentials.instance_credential[0].username, null) : var.OS == "Canonical Ubuntu" ? "ubuntu" : "opc"
  password  = var.OS == "Windows" ? try(data.oci_core_instance_credentials.instance_credential[0].password, null) : "The public_key's private_key that you wrote in terraform.json"
  volume = try([
    for volume_data in oci_core_volume.block_volume :
    {
      "display_name" : volume_data.display_name,
      "size_in_gbs" : volume_data.size_in_gbs,
      "time_created" : volume_data.time_created
      "volume_attach" : [
        for attach_data in oci_core_volume_attachment.block_attach :
        {
          "attachment_type" : attach_data.attachment_type,
          "state" : attach_data.state,
          "time_created" : attach_data.time_created
        }
        if attach_data.volume_id == volume_data.id
      ]
    }
  ], [])
  result = tomap({
    "result" : {
      "Instance_information" : {
        "instance_id" : oci_core_instance.create_instance.id,
        "availability_domain" : oci_core_instance.create_instance.availability_domain,
        "display_name" : oci_core_instance.create_instance.display_name,
        "ip" : {
          "hostname" : oci_core_instance.create_instance.create_vnic_details[0].hostname_label,
          "public_ip" : oci_core_instance.create_instance.public_ip,
          "private_ip" : oci_core_instance.create_instance.create_vnic_details[0].private_ip,
        },
        "time_created" : oci_core_instance.create_instance.time_created
      },
      "Connection_information" : {
        "user_name" : local.user_name,
        "user_password" : local.password
      },
      "Volume_Information" : local.volume
    }
  })
}