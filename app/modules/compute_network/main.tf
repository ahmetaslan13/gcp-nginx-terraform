resource "google_compute_network" "vpc" {
  name                    = "gcp"
  auto_create_subnetworks = false
}