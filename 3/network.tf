#############################  HQ Networks ############################################################

resource google_compute_network "hq_vpc" {
    name                    = var.hq_network_name
    description             = "headquarters network"
    auto_create_subnetworks = false
    routing_mode            = "REGIONAL"
    mtu                     = 1460
}

#Subnet1
resource google_compute_subnetwork "hq_subnet" {
    name          = var.hq_subnet
    description   = "default subnet for headquarters"
    ip_cidr_range = var.hq_ip
    region        = "${substr(var.hq_zone, 0, length(var.hq_zone) - 2)}"
    network       = google_compute_network.hq_vpc.id
}

resource "google_compute_firewall" "allow_http" {
  
  network = google_compute_network.hq_vpc.id

  name        = "allow-http"
  description = "Allow inbound traffic on port 80 for americas region to access hq"
  direction   = "INGRESS"  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["172.16.32.0/24", "172.16.76.0/24", "${var.asia_ip}"]
}



#############################  Americas Network ############################################################

resource google_compute_network "americas_vpc" {
    name                    = var.americas_network_name
    description             = "VPC for americas branch"
    auto_create_subnetworks = false
    routing_mode            = "REGIONAL"
    mtu                     = 1460
}



#Subnet1
resource google_compute_subnetwork "americas_subnet1" {
    name          = var.americas_subnet1_name
    description   = "subnetwork for america 1"
    ip_cidr_range = var.americas_ip1
    region        = "${substr(var.americas_zone, 0, length(var.americas_zone) - 2)}"
    network       = google_compute_network.americas_vpc.self_link
}

#Subnet2
resource google_compute_subnetwork "americas_subnet2" {
    name          = var.americas_subnet2_name
    description   = "subnetwork for america 2"
    ip_cidr_range = var.americas_ip2
    region        = var.americas_subnet_2_region
    network       = google_compute_network.americas_vpc.self_link
}


resource "google_compute_firewall" "allow_rdp_americas" {
  
  network = google_compute_network.americas_vpc.self_link
  name        = "allow-rdp-americas"
  description = "Allow inbound traffic on port 3389 from other company networks"
  direction   = "INGRESS"  
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = ["0.0.0.0/0"]
}



################ Asia Network #################################################################################

resource google_compute_network "asia_vpc" {
    name                    = var.asia_vpc_name
    description             = "headquarters network"
    auto_create_subnetworks = false
    routing_mode            = "REGIONAL"
    mtu                     = 1460
}

#Subnet1
resource google_compute_subnetwork "asia_subnet" {
    name          = var.asia_subnet_name
    description   = "default subnet for asia"
    ip_cidr_range = var.asia_ip
    region        = "${substr(var.asia_zone, 0, length(var.asia_zone) - 2)}"
    network       = google_compute_network.asia_vpc.self_link
}

resource "google_compute_firewall" "allow_rdp_asia" {
  
  network = google_compute_network.asia_vpc.id

  name        = "allow-rdp-asia"
  description = "Allow inbound traffic on port 3389 from other company networks"
  direction   = "INGRESS"  
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = ["0.0.0.0/0"]
}

