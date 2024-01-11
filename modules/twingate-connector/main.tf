resource "twingate_remote_network" "aws_network" {
  count    = var.enable_remote_network ? 1 : 0
  name     = var.network_name
  location = var.network_location
}

resource "twingate_connector" "aws_connector_primary" {
  count             = var.enable_remote_network ? 1 : 0
  name              = var.primary_connector_name
  remote_network_id = twingate_remote_network.aws_network[count.index].id
}

resource "twingate_connector_tokens" "aws_connector_primary_tokens" {
  count        = var.enable_remote_network ? 1 : 0
  connector_id = twingate_connector.aws_connector_primary[count.index].id
  depends_on = [ twingate_connector.aws_connector_primary[0] ]
}

resource "twingate_connector" "aws_connector_secondary" {
  count             = var.enable_remote_network ? 1 : 0
  name              = var.secondary_connector_name
  remote_network_id = twingate_remote_network.aws_network[count.index].id
}

resource "twingate_connector_tokens" "aws_connector_secondary_tokens" {
  count        = var.enable_remote_network ? 1 : 0
  connector_id = twingate_connector.aws_connector_secondary[count.index].id
  depends_on = [ twingate_connector.aws_connector_secondary[0] ]
}

resource "kubernetes_namespace" "namespace_twingate" {
  count = var.enable_twingate_primary || var.enable_twingate_secondary ? 1 : 0
  metadata {
    name = var.kubernetes_namespace
  }
}

resource "helm_release" "twingate-primary" {
  count           = var.enable_twingate_primary ? 1 : 0
  name            = format("twingate-%s", var.primary_connector_name)
  repository      = "https://twingate.github.io/helm-charts"
  chart           = "connector"
  namespace       = var.kubernetes_namespace
  version         = var.twingate_connector_version

  set {
    name  = "connector.network"
    value = var.network
  }

  set {
    name  = "connector.accessToken"
    value = twingate_connector_tokens.aws_connector_primary_tokens[count.index].access_token
  }

  set {
    name  = "connector.refreshToken"
    value = twingate_connector_tokens.aws_connector_primary_tokens[count.index].refresh_token
  }

  depends_on = [
    kubernetes_namespace.namespace_twingate[0],
    twingate_connector.aws_connector_primary[0],
  ]

}

resource "helm_release" "twingate-secondary" {
  count           = var.enable_twingate_secondary ? 1 : 0
  name            = format("twingate-%s", var.secondary_connector_name)
  repository      = "https://twingate.github.io/helm-charts"
  chart           = "connector"
  namespace       = var.kubernetes_namespace
  version         = var.twingate_connector_version

  set {
    name  = "connector.network"
    value = var.network
  }

  set {
    name  = "connector.accessToken"
    value = twingate_connector_tokens.aws_connector_secondary_tokens[count.index].access_token
  }

  set {
    name  = "connector.refreshToken"
    value = twingate_connector_tokens.aws_connector_secondary_tokens[count.index].refresh_token
  }

  depends_on = [
    kubernetes_namespace.namespace_twingate[0],
    twingate_connector.aws_connector_secondary[0],
  ]

}
