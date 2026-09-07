output "cache" {
  description = "contains all redis cache configuration"
  value       = azurerm_redis_cache.this
}

output "access_policy" {
  description = "contains all redis cache access policy configuration"
  value       = azurerm_redis_cache_access_policy.this
}

output "access_policy_assignment" {
  description = "contains all redis cache access policy assignment configuration"
  value       = azurerm_redis_cache_access_policy_assignment.this
}

output "firewall_rules" {
  description = "contains all redis cache firewall rule configuration"
  value       = azurerm_redis_firewall_rule.this
}

output "linked_server" {
  description = "contains all redis cache linked server configuration"
  value       = azurerm_redis_linked_server.this
}
