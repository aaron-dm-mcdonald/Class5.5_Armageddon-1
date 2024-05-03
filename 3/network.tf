#############################  NETWORK 1 ############################################################



resource google_compute_network "network_1" {
    name                    = var.net1
    description             = "Network channel for Net1 variable"
    auto_create_subnetworks = false
    routing_mode            = "REGIONAL"
    mtu                     = 1460
}

output "n1" {
    value = google_compute_network.network_1.name
}


#Subnet1
resource google_compute_subnetwork "network_sub1" {
    name          = var.net1_sub1
    description   = "default subnet secure"
    ip_cidr_range = var.net1_sub1_iprange
    region        = var.net1_sub1_region
    network       = google_compute_network.network_1.id
}

#Subnet2
resource google_compute_subnetwork "network_sub2" {
    name          = var.net1_sub2
    description   = "default subnet2 secure"
    ip_cidr_range = var.net1_sub2_iprange
    region        = var.net1_sub2_region
    network       = google_compute_network.network_1.id
}

##################### Firewall Rules ###########################################################
#ICMP
resource "google_compute_firewall" "net1_icmp"{
    name = "net1-icmp"
    network = google_compute_network.network_1.id
    description = "whodoneit?"
    direction = "INGRESS"
    priority = 65534
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "icmp"
    }
}

#SSH
resource "google_compute_firewall" "net1_ssh"{
    name = "net1-ssh"
    network = google_compute_network.network_1.id
    description = "whodoneit?"
    direction = "INGRESS"
    priority = 65534
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "tcp"
        ports = ["22"]
    }
}



#############################  NETWORK 2 ############################################################

resource google_compute_network "network_2" {
    name                    = var.net2
    description             = "Network channel for Net1 variable"
    auto_create_subnetworks = false
    routing_mode            = "REGIONAL"
    mtu                     = 1460
}

output "n2" {
    value = google_compute_network.network_2.name
}


#Subnet1
resource google_compute_subnetwork "network2_sub1" {
    name          = var.net2_sub1
    description   = "default subnet secure"
    ip_cidr_range = var.net2_sub1_iprange
    region        = var.net2_sub1_region
    network       = google_compute_network.network_2.id
}

#Subnet2
resource google_compute_subnetwork "network2_sub2" {
    name          = var.net2_sub2
    description   = "default subnet2 secure"
    ip_cidr_range = var.net2_sub2_iprange
    region        = var.net2_sub2_region
    network       = google_compute_network.network_2.id
}

####### Firewall Rules ########################################
#>>>
#ICMP
resource "google_compute_firewall" "net2_icmp"{
    name = "net2-icmp"
    network = google_compute_network.network_2.id
    description = "whatforandwhy?"
    direction = "INGRESS"
    priority = 65534
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "icmp"
    }
}

#SSH
resource "google_compute_firewall" "net2_ssh"{
    name = "net2-ssh"
    network = google_compute_network.network_2.id
    description = "whatforandwhy?"
    direction = "INGRESS"
    priority = 65534
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "tcp"
        ports = ["22"]
    }
}