output "cache" {
  description = "contains all redis cache configuration"
  value       = azurerm_redis_cache.redis
}

output "ap" {
  description = "contains all redis cache access policy configuration"
  value       = azurerm_redis_cache_access_policy.ap
}

output "apa" {
  description = "contains all redis cache access policy assignment configuration"
  value       = azurerm_redis_cache_access_policy_assignment.apa
}

output "user_assigned_identities" {
  description = "contains all user assigned identities configuration"
  value       = azurerm_user_assigned_identity.identity
}
