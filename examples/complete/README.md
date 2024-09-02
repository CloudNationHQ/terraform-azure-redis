# Complete

This example highlights the complete usage.

## Types

```hcl
cache = object({
  name           = string
  resource_group = string
  location       = string
  sku_name       = string
  capacity       = number
  family         = string
  subnet_id      = optional(string)
  zones          = optional(list(string))
  redis_configuration = optional(object({
    enable_authentication                   = optional(bool)
    active_directory_authentication_enabled = optional(bool)
  }))
  identity = optional(object({
    type = string
  }))
  patch_schedule = optional(object({
    day_of_week        = string
    start_hour_utc     = number
    maintenance_window = string
  }))
  access_policy = optional(map(object({
    name        = string
    permissions = string
  })))
  access_policy_assignment = optional(map(object({
    name               = string
    access_policy_name = string
    object_id_alias    = string
  })))
  firewall_rules = optional(map(object({
    start_ip = string
    end_ip   = string
  })))
})
```
