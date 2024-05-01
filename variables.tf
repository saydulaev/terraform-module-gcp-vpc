# google_compute_network
variable "name" {
  description = "Name of the resource VPC."
  type        = string
}

variable "description" {
  description = "Description of VPC."
  type        = string
  default     = null
}

variable "auto_create_subnetworks" {
  description = <<EOT
    will create a subnet for each region automatically across 
    the 10.128.0.0/9 address range. W
    hen set to false, the network is created in "custom subnet mode" 
    so the user can explicitly connect subnetwork resources
    EOT
  type        = bool
  default     = null
}

variable "routing_mode" {
  description = "The network-wide routing mode to use."
  type        = string
  default     = null

  validation {
    condition     = var.routing_mode == null || contains(["GLOBAL", "REGIONAL"], var.routing_mode)
    error_message = "Possible values are `REGIONAL` and `GLOBAL`."
  }
}

variable "mtu" {
  description = "Maximum Transmission Unit in bytes."
  type        = number
  default     = null

  validation {
    condition     = var.mtu == null || can(length(var.mtu) >= 1460) && can(length(var.mtu) <= 1500)
    error_message = "The minimum value for this field is 1460 and the maximum value is 1500 bytes."
  }
}

variable "enable_ula_internal_ipv6" {
  description = <<EOT
    Enable ULA internal ipv6 on this network. 
    Enabling this feature will assign a /48 
    from google defined ULA prefix fd20::/20.
    EOT
  type        = bool
  default     = null
}

variable "internal_ipv6_range" {
  description = <<EOT
    When enabling ula internal ipv6, caller optionally can specify the /48 range 
    they want from the google defined ULA prefix fd20::/20. 
    The input must be a valid /48 ULA IPv6 address and must be within 
    the fd20::/20. Operation will fail if the speficied /48 is already in used 
    by another resource. If the field is not speficied, 
    then a /48 range will be randomly allocated from fd20::/20 and 
    returned via this field.
    EOT
  type        = string
  default     = null
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  type        = string
  default     = null
}

variable "delete_default_routes_on_create" {
  description = "Delete default routes (0.0.0.0/0)."
  type        = bool
  default     = false
}

# google_compute_subnetwork
variable "subnets" {
  description = "Subnets"
  type = map(object({
    name                       = optional(string) // The name of the resource, provided by the client when initially creating the resource. The name must be 1-63 characters long, and comply with RFC1035. 
    description                = optional(string) // An optional description of this resource.
    purpose                    = optional(string) // The purpose of the resource. A subnetwork with purpose set to INTERNAL_HTTPS_LOAD_BALANCER is a user-created subnetwork that is reserved for Internal HTTP(S) Load Balancing. If set to INTERNAL_HTTPS_LOAD_BALANCER you must also set the role field.
    role                       = optional(string) // The role of subnetwork. Currently, this field is only used when purpose = INTERNAL_HTTPS_LOAD_BALANCER. The value can be set to ACTIVE or BACKUP. An ACTIVE subnetwork is one that is currently being used for Internal HTTP(S) Load Balancing. A BACKUP subnetwork is one that is ready to be promoted to ACTIVE or is currently draining. 
    private_ip_google_access   = optional(bool)   // When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.
    private_ipv6_google_access = optional(bool)   // The private IPv6 google access type for the VMs in this subnet.
    stack_type                 = optional(string) // The stack type for this subnet to identify whether the IPv6 feature is enabled or not. Possible values are IPV4_ONLY and IPV4_IPV6.
    ipv6_access_type           = optional(string) //  The access type of IPv6 address this subnet holds. It's immutable and can only be specified during creation or the first time the subnet is updated into IPV4_IPV6 dual stack.
    secondary_ip_range = optional(list(object({
      range_name    = string       // The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance.
      ip_cidr_range = list(string) // The range of IP addresses belonging to this subnetwork secondary range.
    })))                           // An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. 
    log_config = optional(object({
      aggregation_interval = optional(string)       // Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. 
      flow_sampling        = optional(string)       // The value of the field must be in [0, 1]. Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported. 
      metadata             = optional(string)       // Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are EXCLUDE_ALL_METADATA, INCLUDE_ALL_METADATA, and CUSTOM_METADATA.
      metadata_fields      = optional(list(string)) // List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is enabled and "metadata" is set to CUSTOM_METADATA.
    }))                                             // Denotes the logging options for the subnetwork flow logs.
    cidrs = list(string)                            // Subnet group cidr ranges IP addresses.
    czs   = optional(list(string))
  }))
  default = {
    "app" = {
      cidrs = ["10.10.10.1/24", "10.10.10.2/24", "10.10.10.3/24"]
      log_config = {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling        = "0.0"
        metadata             = "EXCLUDE_ALL_METADATA"
        metadata_fields      = []
      }
      private_ip_google_access   = true
      private_ipv6_google_access = true
      stack_type                 = "IPV4_ONLY"
      purpose                    = "INTERNAL_HTTPS_LOAD_BALANCER"
      role                       = "ACTIVE"
    }
  }
}

variable "timeouts" {
  description = "Timeouts for module resources"
  type        = map(map(string))
  default = {
    network = {
      create = "20m"
      update = "20m"
      delete = "20m"
    }
    subnetwork = {
      create = "20m"
      update = "20m"
      delete = "20m"
    }
  }
}