resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.187.1.0/24"
  private_ip_google_access = true
}

resource "google_compute_route" "vpc_network_route" {
  name           = "vpc-network-route"
  dest_range     = "0.0.0.0/0"
  network        = google_compute_network.vpc_network.name
  next_hop_gateway = "default-internet-gateway"
}

resource "google_compute_router" "vpc_network_router_us" {
  name    = "vpc-network-router-us"
  region  = "us-central1"
  network = google_compute_network.vpc_network.name
}
resource "google_compute_router_nat" "vpc_network_nat_us" {
  name                               = "vpc-network-nat-us"
  router                             = google_compute_router.vpc_network_router_us.name
  region                             = google_compute_router.vpc_network_router_us.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


resource "google_compute_firewall" "allow_web_traffic" {
  name    = "allow-web-traffic"
  network = google_compute_network.vpc_network.name
  direction = "INGRESS"
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["vpc-network-http"]
}

resource "google_compute_firewall" "allow_managment" {
  name    = "allow-mgmt-traffic"
  network = google_compute_network.vpc_network.name
  direction = "INGRESS"
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["vpc-network-ssh"]
}

resource "google_compute_firewall" "vpc_network_egress" {
  name        = "vpc-network-egress"
  description = "Allow all egress traffic"
  network     = google_compute_network.vpc_network.name
  direction   = "EGRESS"
  priority    = 1000
  allow {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
  target_tags = ["vpc-network-egress"]
}
