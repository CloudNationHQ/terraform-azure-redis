module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.13"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "vnet" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 8.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    address_space  = ["10.0.0.0/16"]
    subnets = {
      sn1 = {
        cidr = ["10.0.0.0/24"]
        nsg  = {}
      }
    }
  }
}

module "redis" {
  source  = "cloudnationhq/redis/azure"
  version = "~> 2.0"

  naming = local.naming

  cache = {
    name           = module.naming.redis_cache.name_unique
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
    sku_name       = "Premium"
    capacity       = 1
    family         = "P"
    subnet_id      = module.vnet.subnets.sn1.id
    zones          = ["1", "2", "3"]

    redis_configuration = {
      active_directory_authentication_enabled = true
    }

    identity = {
      type = "UserAssigned"
    }

    patch_schedule = {
      day_of_week        = "Sunday"
      start_hour_utc     = 0
      maintenance_window = "PT5H"
    }

    access_policy = {
      ap1 = {
        name        = "demo-access-policy"
        permissions = "+@read +@connection +cluster|info"
      }
    }

    access_policy_assignment = {
      apa1 = {
        name               = "demo-access-policy-assignment"
        access_policy_name = "demo-access-policy"
        object_id_alias    = "CurrentUser"
      }
    }

    firewall_rules = {
      rule1 = {
        start_ip = "10.0.0.0"
        end_ip   = "10.0.0.1"
      }
      rule2 = {
        start_ip = "172.12.0.1"
        end_ip   = "172.12.0.10"
      }
    }
  }
}
