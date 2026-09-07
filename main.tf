data "azurerm_client_config" "this" {}

resource "azurerm_redis_cache" "this" {
  resource_group_name = coalesce(
    var.cache.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.cache.location, var.location
  )

  name                               = var.cache.name
  capacity                           = var.cache.capacity
  family                             = var.cache.family
  sku_name                           = var.cache.sku_name
  access_keys_authentication_enabled = var.cache.access_keys_authentication_enabled
  non_ssl_port_enabled               = var.cache.non_ssl_port_enabled
  minimum_tls_version                = var.cache.minimum_tls_version
  private_static_ip_address          = var.cache.private_static_ip_address
  public_network_access_enabled      = var.cache.public_network_access_enabled
  replicas_per_master                = var.cache.replicas_per_master
  replicas_per_primary               = var.cache.replicas_per_primary
  redis_version                      = var.cache.redis_version
  shard_count                        = var.cache.shard_count
  subnet_id                          = var.cache.subnet_id
  zones                              = var.cache.zones
  tenant_settings                    = var.cache.tenant_settings

  dynamic "redis_configuration" {
    for_each = var.cache.redis_configuration != null ? { "this" = var.cache.redis_configuration } : {}

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
    for_each = var.cache.identity != null ? { "this" = var.cache.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "patch_schedule" {
    for_each = var.cache.patch_schedule

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

resource "azurerm_redis_cache_access_policy" "this" {
  for_each = var.cache.access_policy

  name = coalesce(
    each.value.name, each.key
  )

  redis_cache_id = azurerm_redis_cache.this.id
  permissions    = each.value.permissions
}

resource "azurerm_redis_cache_access_policy_assignment" "this" {
  for_each = var.cache.access_policy_assignment

  name = coalesce(
    each.value.name, each.key
  )

  redis_cache_id     = azurerm_redis_cache.this.id
  access_policy_name = each.value.access_policy_name
  object_id_alias    = each.value.object_id_alias

  object_id = coalesce(
    each.value.object_id, data.azurerm_client_config.this.object_id
  )

  depends_on = [
    azurerm_redis_cache_access_policy.this
  ]
}

resource "azurerm_redis_firewall_rule" "this" {
  for_each = var.cache.firewall_rules

  name = coalesce(
    each.value.name,
    each.key
  )

  resource_group_name = coalesce(
    var.cache.resource_group_name, var.resource_group_name
  )

  redis_cache_name = azurerm_redis_cache.this.name
  start_ip         = each.value.start_ip
  end_ip           = each.value.end_ip
}

resource "azurerm_redis_linked_server" "this" {
  for_each = var.cache.linked_server

  target_redis_cache_name = coalesce(
    each.value.target_redis_cache_name, azurerm_redis_cache.this.name
  )

  resource_group_name = coalesce(
    each.value.resource_group_name, azurerm_redis_cache.this.resource_group_name
  )

  linked_redis_cache_id       = each.value.linked_redis_cache_id
  linked_redis_cache_location = each.value.linked_redis_cache_location
  server_role                 = each.value.server_role
}
