<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | will create a subnet for each region automatically across <br>    the 10.128.0.0/9 address range. W<br>    hen set to false, the network is created in "custom subnet mode" <br>    so the user can explicitly connect subnetwork resources | `bool` | `null` | no |
| <a name="input_delete_default_routes_on_create"></a> [delete\_default\_routes\_on\_create](#input\_delete\_default\_routes\_on\_create) | Delete default routes (0.0.0.0/0). | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of VPC. | `string` | `null` | no |
| <a name="input_enable_ula_internal_ipv6"></a> [enable\_ula\_internal\_ipv6](#input\_enable\_ula\_internal\_ipv6) | Enable ULA internal ipv6 on this network. <br>    Enabling this feature will assign a /48 <br>    from google defined ULA prefix fd20::/20. | `bool` | `null` | no |
| <a name="input_internal_ipv6_range"></a> [internal\_ipv6\_range](#input\_internal\_ipv6\_range) | When enabling ula internal ipv6, caller optionally can specify the /48 range <br>    they want from the google defined ULA prefix fd20::/20. <br>    The input must be a valid /48 ULA IPv6 address and must be within <br>    the fd20::/20. Operation will fail if the speficied /48 is already in used <br>    by another resource. If the field is not speficied, <br>    then a /48 range will be randomly allocated from fd20::/20 and <br>    returned via this field. | `string` | `null` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | Maximum Transmission Unit in bytes. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource VPC. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project in which the resource belongs. | `string` | `null` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network-wide routing mode to use. | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets | <pre>map(object({<br>    name                       = optional(string) // The name of the resource, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with RFC1035. <br>    description                = optional(string) // An optional description of this resource.<br>    purpose                    = optional(string) // The purpose of the resource. A subnetwork with purpose set to INTERNAL_HTTPS_LOAD_BALANCER is a user-created subnetwork that is reserved for Internal HTTP(S) Load Balancing. If set to INTERNAL_HTTPS_LOAD_BALANCER you must also set the role field.<br>    role                       = optional(string) // The role of subnetwork. Currently, this field is only used when purpose = INTERNAL_HTTPS_LOAD_BALANCER. The value can be set to ACTIVE or BACKUP. An ACTIVE subnetwork is one that is currently being used for Internal HTTP(S) Load Balancing. A BACKUP subnetwork is one that is ready to be promoted to ACTIVE or is currently draining. <br>    private_ip_google_access   = optional(bool)   // When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.<br>    private_ipv6_google_access = optional(bool)   // The private IPv6 google access type for the VMs in this subnet.<br>    stack_type                 = optional(string) // The stack type for this subnet to identify whether the IPv6 feature is enabled or not. Possible values are IPV4_ONLY and IPV4_IPV6.<br>    ipv6_access_type           = optional(string) //  The access type of IPv6 address this subnet holds. It's immutable and can only be specified during creation or the first time the subnet is updated into IPV4_IPV6 dual stack.<br>    secondary_ip_range = optional(list(object({<br>      range_name    = string       // The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance.<br>      ip_cidr_range = list(string) // The range of IP addresses belonging to this subnetwork secondary range.<br>    })))                           // An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. <br>    log_config = optional(object({<br>      aggregation_interval = optional(string)       // Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. <br>      flow_sampling        = optional(string)       // The value of the field must be in [0, 1]. Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported. <br>      metadata             = optional(string)       // Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are EXCLUDE_ALL_METADATA, INCLUDE_ALL_METADATA, and CUSTOM_METADATA.<br>      metadata_fields      = optional(list(string)) // List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is enabled and "metadata" is set to CUSTOM_METADATA.<br>    }))                                             // Denotes the logging options for the subnetwork flow logs.<br>    cidrs = list(string)                            // Subnet group cidr ranges IP addresses.<br>    czs   = optional(list(string))<br>  }))</pre> | <pre>{<br>  "app": {<br>    "cidrs": [<br>      "10.10.10.1/24",<br>      "10.10.10.2/24",<br>      "10.10.10.3/24"<br>    ],<br>    "log_config": {<br>      "aggregation_interval": "INTERVAL_10_MIN",<br>      "flow_sampling": "0.0",<br>      "metadata": "EXCLUDE_ALL_METADATA",<br>      "metadata_fields": []<br>    },<br>    "private_ip_google_access": true,<br>    "private_ipv6_google_access": true,<br>    "purpose": "INTERNAL_HTTPS_LOAD_BALANCER",<br>    "role": "ACTIVE",<br>    "stack_type": "IPV4_ONLY"<br>  }<br>}</pre> | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Timeouts for module resources | `map(map(string))` | <pre>{<br>  "network": {<br>    "create": "20m",<br>    "delete": "20m",<br>    "update": "20m"<br>  },<br>  "subnetwork": {<br>    "create": "20m",<br>    "delete": "20m",<br>    "update": "20m"<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | Network |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of created VPC. |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of the created VPC. |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | Self-link created VPC. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnetwork resources |
<!-- END_TF_DOCS -->