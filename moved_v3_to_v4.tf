moved {
  from = data.azurerm_client_config.current
  to   = data.azurerm_client_config.this
}

moved {
  from = azurerm_redis_cache.redis
  to   = azurerm_redis_cache.this
}

moved {
  from = azurerm_redis_cache_access_policy.ap
  to   = azurerm_redis_cache_access_policy.this
}

moved {
  from = azurerm_redis_cache_access_policy_assignment.apa
  to   = azurerm_redis_cache_access_policy_assignment.this
}

moved {
  from = azurerm_redis_firewall_rule.fwr
  to   = azurerm_redis_firewall_rule.this
}

moved {
  from = azurerm_redis_linked_server.ls
  to   = azurerm_redis_linked_server.this
}
