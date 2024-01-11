output "remote_network_id" {
  value     = twingate_remote_network.aws_network.*.id
  sensitive = true
}
