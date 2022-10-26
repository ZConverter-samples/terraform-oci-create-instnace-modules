resource "oci_core_security_list" "create_security_list" {
  count          = var.security_list != null ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.get_subnet_infomation[0].vcn_id

  display_name = "${var.vm_name}-security-list"

  dynamic "ingress_security_rules" {
    for_each = [for data in local.ingress_security_list : 
      data
      if lower(data.protocol) == "tcp"
    ]
    content {
      protocol = local.protocol["tcp"]
      source   = ingress_security_rules.value["remote_ip_prefix"]

      tcp_options {
        max = ingress_security_rules.value["port_range_min"]
        min = ingress_security_rules.value["port_range_max"]
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = [for data in local.ingress_security_list : 
      data
      if lower(data.protocol) == "udp"
    ]
    content {
      protocol = local.protocol["udp"]
      source   = ingress_security_rules.value["remote_ip_prefix"]

      udp_options {
        max = ingress_security_rules.value["port_range_min"]
        min = ingress_security_rules.value["port_range_max"]
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = [for data in local.ingress_security_list : 
      data
      if lower(data.protocol) == "icmp"
    ]
    content {
      protocol = local.protocol["icmp"]
      source   = ingress_security_rules.value["remote_ip_prefix"]

      icmp_options {
        type = ingress_security_rules.value["type"]
        code = ingress_security_rules.value["code"]
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = [for data in local.egress_security_list : 
      data
      if lower(data.protocol) == "tcp"
    ]
    content {
      protocol = local.protocol["tcp"]
      destination   = egress_security_rules.value["remote_ip_prefix"]

      tcp_options {
        max = egress_security_rules.value["port_range_min"]
        min = egress_security_rules.value["port_range_max"]
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = [for data in local.egress_security_list : 
      data
      if lower(data.protocol) == "udp"
    ]
    content {
      protocol = local.protocol["udp"]
      destination   = egress_security_rules.value["remote_ip_prefix"]

      udp_options {
        max = egress_security_rules.value["port_range_min"]
        min = egress_security_rules.value["port_range_max"]
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = [for data in local.egress_security_list : 
      data
      if lower(data.protocol) == "icmp"
    ]
    content {
      protocol = local.protocol["icmp"]
      destination   = egress_security_rules.value["remote_ip_prefix"]

      icmp_options {
        type = egress_security_rules.value["type"]
        code = egress_security_rules.value["code"]
      }
    }
  }
}