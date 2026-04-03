output "cache" {
  description = "contains all redis cache configuration"
  value       = azurerm_redis_cache.redis
}

output "access_policy" {
  description = "contains all redis cache access policy configuration"
  value       = azurerm_redis_cache_access_policy.ap
}

output "access_policy_assignment" {
  description = "contains all redis cache access policy assignment configuration"
  value       = azurerm_redis_cache_access_policy_assignment.apa
}

output "firewall_rules" {
  description = "contains all redis cache firewall rule configuration"
  value       = azurerm_redis_firewall_rule.fwr
}

output "linked_server" {
  description = "contains all redis cache linked server configuration"
  value       = azurerm_redis_linked_server.ls
}
