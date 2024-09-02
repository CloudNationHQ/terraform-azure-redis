locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["redis_cache", "redis_firewall_rule", "resource_group", "subnet", "network_security_group", "virtual_network"]
}