# Default

This example illustrates the default setup, in its simplest form.

## Types

```hcl
cache = object({
  name           = string
  resource_group = string
  location       = string
  sku_name       = string
  capacity       = number
  family         = string
})
```
