# Redis Cache

This Terraform module simplifies the setup and management of azure Redis Cache, offering customizable configurations for creating and maintaining redis instances. It ensures a high-performance and scalable in-memory data store, optimized for low-latency and high-throughput applications in the cloud.

## Features

Configures access policies and assignments for secure access control.

Adds firewall rules for enhanced network security.

Supports linked servers for seamless replication and high availability.

Utilization of terratest for robust validation.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_redis_cache.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) (resource)
- [azurerm_redis_cache_access_policy.ap](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache_access_policy) (resource)
- [azurerm_redis_cache_access_policy_assignment.apa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache_access_policy_assignment) (resource)
- [azurerm_redis_firewall_rule.fwr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_firewall_rule) (resource)
- [azurerm_redis_linked_server.ls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_linked_server) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_cache"></a> [cache](#input\_cache)

Description: Contains all redis cache configuration

Type:

```hcl
object({
    name                          = string
    location                      = optional(string, null)
    resource_group_name           = optional(string, null)
    capacity                      = number
    family                        = string
    sku_name                      = string
    non_ssl_port_enabled          = optional(bool, false)
    minimum_tls_version           = optional(string, "1.2")
    private_static_ip_address     = optional(string, null)
    public_network_access_enabled = optional(bool, true)
    replicas_per_master           = optional(number, null)
    replicas_per_primary          = optional(number, null)
    redis_version                 = optional(string, "6")
    shard_count                   = optional(number, null)
    subnet_id                     = optional(string, null)
    zones                         = optional(list(string), null)
    tags                          = optional(map(string))
    redis_configuration = optional(object({
      aof_backup_enabled                      = optional(bool, false)
      aof_storage_connection_string_0         = optional(string, null)
      aof_storage_connection_string_1         = optional(string, null)
      authentication_enabled                  = optional(bool, true)
      active_directory_authentication_enabled = optional(bool, false)
      maxmemory_reserved                      = optional(number, null)
      maxmemory_delta                         = optional(number, null)
      maxmemory_policy                        = optional(string, "volatile-lru")
      data_persistence_authentication_method  = optional(string, null)
      maxfragmentationmemory_reserved         = optional(number, null)
      rdb_backup_enabled                      = optional(bool, false)
      rdb_backup_frequency                    = optional(number, null)
      rdb_backup_max_snapshot_count           = optional(number, null)
      rdb_storage_connection_string           = optional(string, null)
      storage_account_subscription_id         = optional(string, null)
      notify_keyspace_events                  = optional(string, null)
    }), null)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    patch_schedule = optional(object({
      day_of_week        = string
      start_hour_utc     = number
      maintenance_window = optional(string, "PT5H")
    }), null)
    access_policy = optional(map(object({
      name        = optional(string, null)
      permissions = string
    })), {})
    access_policy_assignment = optional(map(object({
      name               = optional(string, null)
      access_policy_name = string
      object_id          = optional(string, null)
      object_id_alias    = string
    })), {})
    firewall_rules = optional(map(object({
      name     = optional(string, null)
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
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_access_policy"></a> [access\_policy](#output\_access\_policy)

Description: contains all redis cache access policy configuration

### <a name="output_access_policy_assignment"></a> [access\_policy\_assignment](#output\_access\_policy\_assignment)

Description: contains all redis cache access policy assignment configuration

### <a name="output_cache"></a> [cache](#output\_cache)

Description: contains all redis cache configuration
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-redis/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-redis" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/redis)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/redis)
