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

data "oci_core_subnet" "get_subnet_infomation" {
  count     = var.security_list != null ? 1 : 0
  subnet_id = var.subnet_ocid
}

data "oci_core_instance_credentials" "instance_credential" {
  count       = var.OS == "Windows" ? 1 : 0
  instance_id = oci_core_instance.create_instance.id
}