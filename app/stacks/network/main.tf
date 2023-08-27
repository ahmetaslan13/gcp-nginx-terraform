
module "network" {
  source = "../../modules/compute_network"
  name   = var.network_name
}


module "public_subnetwork" {
  source        = "../../modules/compute_subnetwork"
  name          = "public-${var.subnetwork_name}"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network_id    = module.network.self_link
}

module "private_subnetwork" {
  source        = "../../modules/compute_subnetwork"
  name          = "private-${var.subnetwork_name}"
  ip_cidr_range = var.private_ip_cidr_range
  region        = var.region
  network_id    = module.network.self_link
}

resource "google_compute_instance" "public_instance" {
  name         = "public-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = module.network.self_link
    subnetwork = module.public_subnetwork.self_link

  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo service nginx start
  EOF
}

#Ingress firewall rules
resource "google_compute_firewall" "ssh" {
  name    = "vm-ssh"
  network = module.network.self_link
 

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = "20"
}

# Egress rules
resource "google_compute_firewall" "egress" {
  name    = "egress-firewall"
  network = module.network.self_link

  priority = 1000

  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}