# terraform-twingate-twingate
Terraform Twingate Module

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

This module can be used to create Twingate resources. It has one sub-module named a connector, which can be used to create a Twingate connector. Also, the main module can help create Twingate resources like networks, policies, groups, etc.

## Usage

```hcl
module "twingate_resource" {
    count             = var.enable_my_twingate ? 1 : 0
    source            = "github.com/terraform-twingate-twingate"
    endpoints         = local.twingate_endpoints
    remote_network_id = local.remote_network_id[0]
}
```
See [example](example/) for more details.


