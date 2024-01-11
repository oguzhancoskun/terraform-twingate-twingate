variable "network" {
  type    = string
  default = "vpngateway"
}

variable "network_name" {
    type        = string
    description = "network name"
}

variable "network_location" {
    type        = string
    description = "(String) The location of the Remote Network. Must be one of the following: AWS, AZURE, GOOGLE_CLOUD, ON_PREMISE, OTHER"
    default     = "AWS"
}

variable "twingate_api_token" {}

variable "enable_remote_network" {
  type    = bool
  default = true
}

variable "enable_twingate_primary" {
  type    = bool
  default = true
}

variable "enable_twingate_secondary" {
  type    = bool
  default = true
}

variable "kubernetes_namespace" {
  type    = string
  default = "twingate"
}

variable "primary_connector_name" {
  type    = string
  default = "primary connector name"
}

variable "secondary_connector_name" {
  type    = string
  default = "secondary connector name"
  
}

variable "twingate_connector_version" {
    type    = string
    default = "0.1.23"
}

