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
    name                 = module.naming.redis_cache.name_unique
    resource_group_name  = module.rg.groups.demo.name
    location             = module.rg.groups.demo.location
    sku_name             = "Premium"
    capacity             = 1
    family               = "P"
    replicas_per_primary = 2
    zones                = ["1", "2", "3"]
  }
}
