data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "InstanceImageOCID" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.OS
  operating_system_version = var.OS_version
  shape                    = var.instance_type_name

  filter {
    name   = "display_name"
    values = var.custom_image_name == null ? ["^*$"] : [var.custom_image_name]
    regex  = true
  }
}

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

resource "oci_core_volume" "block_volume" {
  count               = length(var.additional_volumes)
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "${var.vm_name}-${count.index}"
  size_in_gbs         = var.additional_volumes[count.index]
}

resource "oci_core_volume_attachment" "block_attach" {
  count           = length(var.additional_volumes)
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.create_instance.id
  volume_id       = oci_core_volume.block_volume[count.index].id
  device          = var.OS == "Windows" ? null : "${local.volume_device[count.index]}"
  use_chap        = true
}

data "oci_core_instance_credentials" "instance_credential" {
  count       = var.OS == "Windows" ? 1 : 0
  instance_id = oci_core_instance.create_instance.id
}