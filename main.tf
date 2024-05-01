locals {
  _subnets_gcp = flatten(
    [for subnet in keys(var.subnets) :
      [for idx, cidr in var.subnets[subnet].cidrs :
        merge(
          {
            ip_cidr_range              = cidr
            name                       = lower(format("%s-%s-%s", var.name, replace(subnet, "_", "-"), idx))
            purpose                    = try(var.subnets[subnet].purpose, null)
            role                       = try(var.subnets[subnet].purpose, null) == "INTERNAL_HTTPS_LOAD_BALANCER" ? try(var.subnets[subnet].role, "ACTIVE") : null
            secondary_ip_range         = try(var.subnets[subnet].secondary_ip_range, null)
            stack_type                 = try(var.subnets[subnet].stack_type, null)
            ipv6_access_type           = try(var.subnets[subnet].ipv6_access_type, "INTERNAL")
            private_ip_google_access   = try(var.subnets[subnet].private_ip_google_access, true)
            private_ipv6_google_access = try(var.subnets[subnet].private_ipv6_google_access, "ENABLE_GOOGLE_ACCESS")
            region                     = try(var.subnets[subnet].region, null)
            log_config = merge({
              aggregation_interval = coalesce(try(var.subnets[subnet].log_config.aggregation_interval, null), "INTERVAL_5_SEC")
              flow_sampling        = coalesce(try(var.subnets[subnet].log_config.flow_sampling, "0.0"), "0.5")
              metadata             = coalesce(try(var.subnets[subnet].log_config.metadata, null), "INCLUDE_ALL_METADATA")
              metadata_fields      = try(var.subnets[subnet].log_config.metadata, null) != "CUSTOM_METADATA" ? try(var.subnets[subnet].log_config.metadata_fields, []) : null
              filter_expr          = length(try(var.subnets[subnet].log_config.filter_expr, "")) > 0 ? var.subnets[subnet].log_config.filter_expr : null
            })
          },
          {
            "subnet_group" = subnet,
          }
        )
      ]
    ]
  )

  subnets_gcp = { for s in local._subnets_gcp : s.ip_cidr_range => s }
}

data "google_compute_zones" "available" {
  provider = google
}

resource "google_compute_network" "this" {
  name                            = var.name
  description                     = var.description
  routing_mode                    = var.routing_mode
  enable_ula_internal_ipv6        = var.enable_ula_internal_ipv6
  internal_ipv6_range             = var.internal_ipv6_range
  delete_default_routes_on_create = var.delete_default_routes_on_create
  project                         = var.project
  auto_create_subnetworks         = var.auto_create_subnetworks
  mtu                             = var.mtu

  timeouts {
    create = var.timeouts.network.create
    update = var.timeouts.network.update
    delete = var.timeouts.network.delete
  }
}

resource "google_compute_subnetwork" "this" {
  project = var.project

  for_each = local.subnets_gcp

  ip_cidr_range              = each.value.ip_cidr_range
  name                       = each.value.name
  network                    = google_compute_network.this.id
  description                = "${var.description} subnet ${each.value.name}"
  purpose                    = each.value.purpose
  role                       = each.value.role
  private_ip_google_access   = try(each.value.private_ip_google_access, true)
  private_ipv6_google_access = each.value.private_ipv6_google_access
  region                     = each.value.region
  stack_type                 = each.value.stack_type
  ipv6_access_type           = each.value.ipv6_access_type

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_range == null ? [] : each.value.secondary_ip_range

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = "0.5"
    metadata             = "EXCLUDE_ALL_METADATA"
  }
  /*
  dynamic "log_config" {
    // for_each = each.value.log_config == null ? {} : each.value.log_config
    for_each = each.value.log_config

    content {
      aggregation_interval = lookup(log_config.value, "aggregation_interval", null)
      flow_sampling        = lookup(log_config.value, "flow_sampling", null)
      metadata             = lookup(log_config.value, "metadata", null)
      metadata_fields      = lookup(log_config.value, "metadata_fields", null)
      filter_expr          = lookup(log_config.value, "filter_expr", null)
    }
  }
  */

  depends_on = [
    google_compute_network.this
  ]

  timeouts {
    create = var.timeouts.subnetwork.create
    update = var.timeouts.subnetwork.update
    delete = var.timeouts.subnetwork.delete
  }
}