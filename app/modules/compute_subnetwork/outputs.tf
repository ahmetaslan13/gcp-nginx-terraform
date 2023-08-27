output "self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "The unique name of the network"
}