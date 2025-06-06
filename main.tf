data "azurerm_client_config" "current" {}

resource "azurerm_redis_cache" "redis" {
  resource_group_name = coalesce(
    lookup(
      var.cache, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(var.cache, "location", null
    ), var.location
  )

  name                          = var.cache.name
  capacity                      = var.cache.capacity
  family                        = var.cache.family
  sku_name                      = var.cache.sku_name
  non_ssl_port_enabled          = var.cache.non_ssl_port_enabled
  minimum_tls_version           = var.cache.minimum_tls_version
  private_static_ip_address     = var.cache.private_static_ip_address
  public_network_access_enabled = var.cache.public_network_access_enabled
  replicas_per_master           = var.cache.replicas_per_master
  replicas_per_primary          = var.cache.replicas_per_primary
  redis_version                 = var.cache.redis_version
  shard_count                   = var.cache.shard_count
  subnet_id                     = var.cache.subnet_id
  zones                         = var.cache.zones

  dynamic "redis_configuration" {
    for_each = lookup(var.cache, "redis_configuration", null) != null ? [var.cache.redis_configuration] : []

    content {
      aof_backup_enabled                      = redis_configuration.value.aof_backup_enabled
      aof_storage_connection_string_0         = redis_configuration.value.aof_storage_connection_string_0
      aof_storage_connection_string_1         = redis_configuration.value.aof_storage_connection_string_1
      authentication_enabled                  = redis_configuration.value.authentication_enabled
      active_directory_authentication_enabled = redis_configuration.value.active_directory_authentication_enabled
      maxmemory_reserved                      = redis_configuration.value.maxmemory_reserved
      maxmemory_delta                         = redis_configuration.value.maxmemory_delta
      maxmemory_policy                        = redis_configuration.value.maxmemory_policy
      data_persistence_authentication_method  = redis_configuration.value.data_persistence_authentication_method
      maxfragmentationmemory_reserved         = redis_configuration.value.maxfragmentationmemory_reserved
      rdb_backup_enabled                      = redis_configuration.value.rdb_backup_enabled
      rdb_backup_frequency                    = redis_configuration.value.rdb_backup_frequency
      rdb_backup_max_snapshot_count           = redis_configuration.value.rdb_backup_max_snapshot_count
      rdb_storage_connection_string           = redis_configuration.value.rdb_storage_connection_string
      storage_account_subscription_id         = redis_configuration.value.storage_account_subscription_id
      notify_keyspace_events                  = redis_configuration.value.notify_keyspace_events
    }
  }

  dynamic "identity" {
    for_each = lookup(var.cache, "identity", null) != null ? [var.cache.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_idsmain
    }
  }

  dynamic "patch_schedule" {
    for_each = lookup(var.cache, "patch_schedule", null) != null ? [var.cache.patch_schedule] : []

    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = patch_schedule.value.maintenance_window
    }
  }

  tags = coalesce(
    var.cache.tags, var.tags
  )
}

resource "azurerm_redis_cache_access_policy" "ap" {
  for_each = {
    for key, ap in try(var.cache.access_policy, {}) : key => ap
  }

  name = coalesce(
    each.value.name, each.key
  )

  redis_cache_id = azurerm_redis_cache.redis.id
  permissions    = each.value.permissions
}

resource "azurerm_redis_cache_access_policy_assignment" "apa" {
  for_each = {
    for key, apa in try(var.cache.access_policy_assignment, {}) : key => apa
  }

  name = coalesce(
    each.value.name, each.key
  )

  redis_cache_id     = azurerm_redis_cache.redis.id
  access_policy_name = each.value.access_policy_name
  object_id_alias    = each.value.object_id_alias

  object_id = coalesce(
    each.value.object_id, data.azurerm_client_config.current.object_id
  )

  depends_on = [
    azurerm_redis_cache_access_policy.ap
  ]
}

resource "azurerm_redis_firewall_rule" "fwr" {
  for_each = {
    for key, rule in try(var.cache.firewall_rules, {}) : key => rule
  }

  name = coalesce(
    each.value.name,
    try(
      replace(join("-", [var.naming.redis_firewall_rule, each.key]), "-", "_"), null
    ), each.key
  )

  resource_group_name = coalesce(
    lookup(
      var.cache, "resource_group_name", null
    ), var.resource_group_name
  )

  redis_cache_name = azurerm_redis_cache.redis.name
  start_ip         = each.value.start_ip
  end_ip           = each.value.end_ip
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
