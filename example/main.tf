provider "twingate" {
  alias     = "mytwingate"
  api_token = var.twingate_api_token_teammate
  network   = "Your Network Name"
}

#
# Configure the Twingate Connector With Module
# This Module can create twingate connectors and create pods on your EKS Cluster
#

module "twingate_twingate-connector" {
  providers = {
    twingate = twingate.mytwingate
  }
  source  = "app.terraform.io/YourTerraformAccount/twingate/twingate//modules/twingate-connector"
  twingate_api_token = var.twingate_api_token
  network = "Your Network Name"
  network_name = format("%s-%s", var.twingate_network_location, var.project_name)
  network_location = var.twingate_network_location
  primary_connector_name = "atticus-finch"
  secondary_connector_name = "scout-finch"
}

variable "twingate_api_token" {
  type = string
  description = "Twingate API Token"
}

variable "twingate_network_location" {
  type = string
  description = "Twingate Network Location"
}

variable "project_name" {
  type = string
  description = "Project Name"
  
}

# This output may need to access from cross account.
output "remote_network_id" {
  value     = module.twingate_twingate-connector.remote_network_id
  sensitive = true
}

#
# Configure the Twingate Resource With Module
#

locals {
  remote_network_id   = output.remote_network_id
  twingate_endpoints  = yamldecode(file("files/twingate_endpoints.yaml"))
}

module "twingate_resource" {
    count             = var.enable_my_twingate ? 1 : 0
    source            = "app.terraform.io/YourTerraformAccount/twingate/twingate"
    endpoints         = local.twingate_endpoints
    remote_network_id = local.remote_network_id[0]
}

variable "enable_my_twingate" {
  type = bool
  description = "Enable Twingate"
  default = true
  
}
