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

module "vnet" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 10.0"

  vnet = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.0.0.0/16"]
    subnets = {
      redis = {
        address_prefixes       = ["10.0.0.0/24"]
        network_security_group = {}
      }
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
    sku_name            = "Premium"
    capacity            = 1
    family              = "P"

    subnet_id                 = module.vnet.subnets.redis.id
    private_static_ip_address = "10.0.0.10"
  }
}
