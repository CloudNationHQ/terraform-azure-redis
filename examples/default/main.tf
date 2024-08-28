module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.13"

  suffix = ["redis", "default"]
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

module "redis" {
  source = "cloudnationhq/redis/azure"
  version = "~> 1.0"

  cache = {
    name           = module.naming.redis_cache.name
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
    sku_name       = "Basic"
    capacity       = 1
    family         = "C"
    redis_version  = "6"
  }
}