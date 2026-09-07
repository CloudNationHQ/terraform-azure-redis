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
    sku_name            = "Standard"
    capacity            = 1
    family              = "C"

    redis_configuration = {
      active_directory_authentication_enabled = true
    }

    access_policy = {
      readonly = {
        name        = "demo-readonly"
        permissions = "+@read +@connection +cluster|info"
      }
      readwrite = {
        permissions = "+@read +@write +@connection"
      }
    }

    access_policy_assignment = {
      current_user = {
        access_policy_name = "readwrite"
        object_id_alias    = "CurrentUser"
      }
    }
  }
}
