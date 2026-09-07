module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.32"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "redis" {
  source  = "cloudnationhq/redis/azure"
  version = "~> 4.0"

  cache = {
    name                = module.naming.redis_cache.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
    sku_name            = "Basic"
    capacity            = 1
    family              = "C"

    firewall_rules = {
      office = {
        start_ip = "10.0.0.0"
        end_ip   = "10.0.0.255"
      }
      vpn = {
        name     = "redis_vpn"
        start_ip = "172.16.0.1"
        end_ip   = "172.16.0.10"
      }
    }
  }
}
