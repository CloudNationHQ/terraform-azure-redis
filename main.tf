data "azurerm_client_config" "current" {}

resource "azurerm_redis_cache" "redis" {
  name                          = var.cache.name
  location                      = coalesce(lookup(var.cache, "location", null), var.location)
  resource_group_name           = coalesce(lookup(var.cache, "resource_group", null), var.resource_group)
  capacity                      = var.cache.capacity
  family                        = var.cache.family
  sku_name                      = var.cache.sku_name
  non_ssl_port_enabled          = try(var.cache.non_ssl_port_enabled, false)
  minimum_tls_version           = try(var.cache.minimum_tls_versio, "1.2")
  private_static_ip_address     = try(var.cache.private_static_ip_address, null)
  public_network_access_enabled = try(var.cache.public_network_access_enabled, true)
  replicas_per_master           = try(var.cache.replicas_per_master, null)
  replicas_per_primary          = try(var.cache.replicas_per_primary, null)
  redis_version                 = try(var.cache.redis_version, "6")
  shard_count                   = try(var.cache.shard_count, null)
  subnet_id                     = try(var.cache.subnet_id, null)
  zones                         = try(var.cache.zones, null)

  dynamic "redis_configuration" {
    for_each = lookup(var.cache, "redis_configuration", null) != null ? [var.cache.redis_configuration] : []

    content {
      aof_backup_enabled                      = try(redis_configuration.value.aof_backup_enabled, false)
      aof_storage_connection_string_0         = try(redis_configuration.value.aof_storage_connection_string_0, null)
      aof_storage_connection_string_1         = try(redis_configuration.value.aof_storage_connection_string_1, null)
      authentication_enabled                  = try(redis_configuration.value.authentication_enabled, true)
      active_directory_authentication_enabled = try(redis_configuration.value.active_directory_authentication_enabled, false)
      maxmemory_reserved                      = try(redis_configuration.value.maxmemory_reserved, null)
      maxmemory_delta                         = try(redis_configuration.value.maxmemory_delta, null)
      maxmemory_policy                        = try(redis_configuration.value.maxmemory_policy, "volatile-lru")
      data_persistence_authentication_method  = try(redis_configuration.value.data_persistence_authentication_method, null)
      maxfragmentationmemory_reserved         = try(redis_configuration.value.maxfragmentationmemory_reserved, null)
      rdb_backup_enabled                      = try(redis_configuration.value.rdb_backup_enabled, false)
      rdb_backup_frequency                    = try(redis_configuration.value.rdb_backup_frequency, null)
      rdb_backup_max_snapshot_count           = try(redis_configuration.value.rdb_backup_max_snapshot_count, null)
      rdb_storage_connection_string           = try(redis_configuration.value.rdb_storage_connection_string, null)
      storage_account_subscription_id         = try(redis_configuration.value.storage_account_subscription_id, null)
      notify_keyspace_events                  = try(redis_configuration.value.notify_keyspace_events, null)
    }
  }

  dynamic "identity" {
    for_each = lookup(var.cache, "identity", null) != null ? [var.cache.identity] : []
    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }

  dynamic "patch_schedule" {
    for_each = lookup(var.cache, "patch_schedule", null) != null ? [var.cache.patch_schedule] : []
    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = try(patch_schedule.value.maintenance_window, "PT5H")
    }
  }

  tags = try(var.cache.tags, var.tags)

}

resource "azurerm_user_assigned_identity" "identity" {
  for_each = lookup(var.cache, "identity", null) != null ? (
    (lookup(var.cache.identity, "type", null) == "UserAssigned" ||
    lookup(var.cache.identity, "type", null) == "SystemAssigned, UserAssigned") &&
    lookup(var.cache.identity, "identity_ids", null) == null ? { "identity" = var.cache.identity } : {}
  ) : {}

  name                = try(each.value.name, "uai-${var.cache.name}")
  resource_group_name = var.cache.resource_group
  location            = var.cache.location
  tags                = try(each.value.tags, var.tags)
}

resource "azurerm_redis_cache_access_policy" "ap" {
  for_each = {
    for key, ap in try(var.cache.access_policy, {}) : key => ap
  }

  name           = try(each.value.name, each.key)
  redis_cache_id = azurerm_redis_cache.redis.id
  permissions    = each.value.permissions
}

resource "azurerm_redis_cache_access_policy_assignment" "apa" {
  for_each = {
    for key, apa in try(var.cache.access_policy_assignment, {}) : key => apa
  }

  name               = try(each.value.name, each.key)
  redis_cache_id     = azurerm_redis_cache.redis.id
  access_policy_name = each.value.access_policy_name
  object_id          = try(each.value.object_id, data.azurerm_client_config.current.object_id)
  object_id_alias    = each.value.object_id_alias

  depends_on = [
    azurerm_redis_cache_access_policy.ap
  ]
}

resource "azurerm_redis_firewall_rule" "fwr" {
  for_each = {
    for key, rule in try(var.cache.firewall_rules, {}) : key => rule
  }

  name                = try(each.value.name, join("_", [var.naming.redis_firewall_rule, each.key]))
  redis_cache_name    = azurerm_redis_cache.redis.name
  resource_group_name = coalesce(lookup(var.cache, "resource_group", null), var.resource_group)
  start_ip            = each.value.start_ip
  end_ip              = each.value.end_ip
}

resource "azurerm_redis_linked_server" "ls" {
  for_each = {
    for key, ls in try(var.cache.linked_server, {}) : key => ls
  }

  target_redis_cache_name     = each.value.target_redis_cache_name
  resource_group_name         = each.value.resource_group_name
  linked_redis_cache_id       = each.value.linked_redis_cache_id
  linked_redis_cache_location = each.value.linked_redis_cache_location
  server_role                 = each.value.server_role
}
