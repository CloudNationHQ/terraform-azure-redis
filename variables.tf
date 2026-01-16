variable "cache" {
  description = "Contains all redis cache configuration"
  type = object({
    name                               = string
    location                           = optional(string)
    resource_group_name                = optional(string)
    capacity                           = number
    family                             = string
    sku_name                           = string
    access_keys_authentication_enabled = optional(bool, true)
    non_ssl_port_enabled               = optional(bool, false)
    minimum_tls_version                = optional(string, "1.2")
    private_static_ip_address          = optional(string)
    public_network_access_enabled      = optional(bool, true)
    replicas_per_master                = optional(number)
    replicas_per_primary               = optional(number)
    redis_version                      = optional(string, "6")
    shard_count                        = optional(number)
    subnet_id                          = optional(string)
    zones                              = optional(list(string))
    tenant_settings                    = optional(map(string))
    tags                               = optional(map(string))
    redis_configuration = optional(object({
      aof_backup_enabled                      = optional(bool, false)
      aof_storage_connection_string_0         = optional(string)
      aof_storage_connection_string_1         = optional(string)
      authentication_enabled                  = optional(bool, true)
      active_directory_authentication_enabled = optional(bool, false)
      maxmemory_reserved                      = optional(number)
      maxmemory_delta                         = optional(number)
      maxmemory_policy                        = optional(string, "volatile-lru")
      data_persistence_authentication_method  = optional(string)
      maxfragmentationmemory_reserved         = optional(number)
      rdb_backup_enabled                      = optional(bool, false)
      rdb_backup_frequency                    = optional(number)
      rdb_backup_max_snapshot_count           = optional(number)
      rdb_storage_connection_string           = optional(string)
      storage_account_subscription_id         = optional(string)
      notify_keyspace_events                  = optional(string)
    }))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    patch_schedule = optional(object({
      day_of_week        = string
      start_hour_utc     = number
      maintenance_window = optional(string, "PT5H")
    }))
    access_policy = optional(map(object({
      name        = optional(string)
      permissions = string
    })), {})
    access_policy_assignment = optional(map(object({
      name               = optional(string)
      access_policy_name = string
      object_id          = optional(string)
      object_id_alias    = string
    })), {})
    firewall_rules = optional(map(object({
      name     = optional(string)
      start_ip = string
      end_ip   = string
    })), {})
    linked_server = optional(map(object({
      target_redis_cache_name     = string
      resource_group_name         = string
      linked_redis_cache_id       = string
      linked_redis_cache_location = string
      server_role                 = string
    })), {})
  })

  validation {
    condition     = var.cache.location != null || var.location != null
    error_message = "location must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.cache.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the object or as a separate variable."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
