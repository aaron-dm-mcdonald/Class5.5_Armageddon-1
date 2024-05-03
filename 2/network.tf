resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  region        = "${substr(var.zone, 0, length(var.zone) - 2)}"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.187.1.0/24"
}

resource "google_compute_firewall" "allow_web_traffic" {
  name    = "allow-web-traffic"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

 

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_managment" {
  name    = "allow-mgmt-traffic"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

   allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_internal_traffic" {
  name    = "allow-internal-traffic"
  network = google_compute_network.vpc_network.name
  
   # Allow traffic from any source within the VPC
  
  allow {
    protocol = "all"
  }
  source_ranges = [
    "10.0.0.0/8", 
    "172.16.0.0/12",
    "192.168.0.0/16" 
    ]
  
}