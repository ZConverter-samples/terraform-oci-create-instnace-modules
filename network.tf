resource "oci_core_network_security_group" "create_network_security_group" {
  count          = var.create_security_group_rules != null ? 1 : 0
  compartment_id = var.compartment_ocid
  vcn_id         = data.oci_core_subnet.get_subnet_infomation[0].vcn_id

  display_name = "${var.vm_name}-security-groups"
}

resource "oci_core_network_security_group_security_rule" "ingress" {
  count = length(local.ingress_security_groups)
  network_security_group_id = oci_core_network_security_group.create_network_security_group[0].id
  direction = upper(local.ingress_security_groups[count.index].direction)
  protocol = local.protocol[lower(local.ingress_security_groups[count.index].protocol)]
  source = local.ingress_security_groups[count.index].remote_ip_prefix
  source_type = "CIDR_BLOCK"

  dynamic "tcp_options" {
    for_each = contains(["tcp", "tcpv6"], lower(local.ingress_security_groups[count.index].protocol)) ? [1] : []
    content {
      destination_port_range {
        min = local.ingress_security_groups[count.index].port_range_min == 0 ? 1 : local.ingress_security_groups[count.index].port_range_min
        max = local.ingress_security_groups[count.index].port_range_max == 0 ? 65535 : local.ingress_security_groups[count.index].port_range_max
      }
    }
  }

  dynamic "udp_options" {
    for_each = contains(["udp", "udpv6"], lower(local.ingress_security_groups[count.index].protocol)) ? [1] : []
    content {
      destination_port_range {
        min = local.ingress_security_groups[count.index].port_range_min == 0 ? 1 : local.ingress_security_groups[count.index].port_range_min
        max = local.ingress_security_groups[count.index].port_range_max == 0 ? 65535 : local.ingress_security_groups[count.index].port_range_max
      }
    }
  }

  dynamic "icmp_options" {
    for_each = contains(["icmp", "icmpv6"], lower(local.ingress_security_groups[count.index].protocol)) ? [1] : []
    content {
      type = local.ingress_security_groups[count.index].type
      code = local.ingress_security_groups[count.index].code
    }
  }
}
