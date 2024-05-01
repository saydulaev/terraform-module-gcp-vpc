output "network" {
  description = "Network"
  value       = google_compute_network.this
}

output "network_name" {
  description = "Name of the created VPC."
  value       = google_compute_network.this.name
}

output "network_id" {
  description = "ID of created VPC."
  value       = google_compute_network.this.id
}

output "network_self_link" {
  description = "Self-link created VPC."
  value       = google_compute_network.this.self_link
}

output "subnets" {
  description = "The subnetwork resources"
  value       = values(google_compute_subnetwork.this)[*]
}