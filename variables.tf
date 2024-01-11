variable "endpoints" {
  description = "Map of endpoints. Each value is a list where the first element is the group list and the second element is the port list."
  type = map(object({
    groups    = list(string)
    tcp_ports = list(string)
    udp_ports = list(string)
    alias     = optional(string)
    name      = optional(string)
  }))
}

variable "allow_icmp" {
    description = "Allow ICMP protocol"
    type = bool
    default = true
}

variable "remote_network_id" {
    description = "Remote network ID"
}

variable "policy_name" {
  type    = string
  default = "Default Policy"
  description = "name of the policy to use"
}

variable "is_groups_managed" {
  type    = bool
  default = true
  description = "Whether to manage groups"
  
}

variable "twingate_group_list" {
  type    = list(string)
  default = []
  description = "List of groups to create if needed"
  
}
