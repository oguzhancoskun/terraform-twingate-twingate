terraform {
  required_providers {
    twingate = {
      source  = "twingate/twingate"
      version = "~> 1.2.6"
    }
  }
}
resource "twingate_group" "groups" {
  for_each = toset(var.twingate_group_list)
  name = each.key
}

data "twingate_security_policy" "policy" {
  name = var.policy_name
}

data "twingate_groups" "groups" {
  for_each = toset(flatten([
    for key, value in var.endpoints : value.groups
  ]))
  name = each.key
}

resource "twingate_resource" "resource" {
  for_each = var.endpoints

  name               = each.value.name != null ? each.value.name : each.key
  address            = each.key
  remote_network_id  = var.remote_network_id
  security_policy_id = data.twingate_security_policy.policy.id

  protocols {
    allow_icmp = var.allow_icmp

    tcp {
      policy = contains(each.value.tcp_ports, "ALL") ? "ALLOW_ALL" : (length(each.value.tcp_ports) != 0 ? "RESTRICTED" : "DENY_ALL")
      ports  = contains(each.value.tcp_ports, "ALL") || length(each.value.tcp_ports) == 0 ? null : each.value.tcp_ports
    }

    udp {
      policy = contains(each.value.udp_ports, "ALL") ? "ALLOW_ALL" : (length(each.value.udp_ports) != 0 ? "RESTRICTED" : "DENY_ALL")
      ports  = contains(each.value.udp_ports, "ALL") || length(each.value.udp_ports) == 0 ? null : each.value.udp_ports
    }
  }

  access {
    group_ids = [
      for group in each.value.groups :
      data.twingate_groups.groups[group].groups[0].id
    ]
  }

  is_active = true

  alias = each.value.alias != "" ? each.value.alias : null

is_browser_shortcut_enabled = can(cidrsubnet(each.key, 0, 0)) || can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", each.key)) ? false : true
}
