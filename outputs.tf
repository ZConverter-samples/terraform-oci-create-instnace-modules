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

output "result" {
  value = local.result
}

resource "local_file" "output_result" {
  filename = "${path.cwd}/${var.vm_name}_result.json"

  content = jsonencode(local.result)
}