module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.13"

  suffix = ["demo", "complete"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "vnet" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 2.0"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.0.0.0/16"]
    subnets = {
      sn1 = {
        cidr = ["10.0.0.0/24"]
        nsg  = {}
      }
    }
  }
}

module "redis" {
  source = "cloudnationhq/redis/azure"
  version = "~> 1.0"

  naming = local.naming

  cache = {
    name           = module.naming.redis_cache.name
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
    sku_name       = "Premium"
    capacity       = 1
    family         = "P"
    redis_version  = "6"
    subnet_id      = module.vnet.subnets.sn1.id
    zones          = ["1", "2", "3"]
    redis_configuration = {
      enable_authentication                   = true
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
      local_ip = {
        start_ip = chomp(data.http.current_public_ip.response_body)
        end_ip   = chomp(data.http.current_public_ip.response_body)
      }
      firewall_rule1 = {
        start_ip = "10.0.0.0"
        end_ip   = "10.0.0.1"
      }
      firewall_rule2 = {
        start_ip = "172.12.0.1"
        end_ip   = "172.12.0.10"
      }
    }

    tags = {}
  }
}