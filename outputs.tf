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
