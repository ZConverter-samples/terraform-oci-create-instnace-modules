resource "oci_core_instance" "create_instance" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = var.vm_name
  shape               = var.instance_type_name

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet_ocid
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  dynamic "shape_config" {
    for_each = local.instance_type_split[length(local.instance_type_split) - 1] == "Flex" ? [1] : []
    content {
      memory_in_gbs = var.instance_memory_in_gbs
      ocpus         = var.instance_cpus
    }
  }

  metadata = {
    ssh_authorized_keys = local.ssh_authorized_keys
    user_data           = local.user_data_file_path
  }
}