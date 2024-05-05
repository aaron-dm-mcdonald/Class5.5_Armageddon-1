############################## Gateway 1 - HQ ##########################################################
resource "google_compute_vpn_gateway" "gateway-1" {
    name = "hq-gateway"
    network = google_compute_network.hq_vpc.id
    region = "${substr(var.hq_zone, 0, length(var.hq_zone) - 2)}"
    depends_on = [ google_compute_subnetwork.hq_subnet ]
}


resource "google_compute_address" "st1" {
  name   = "hq-static-ip"
  region = "${substr(var.hq_zone, 0, length(var.hq_zone) - 2)}"
}


#Fowarding Rule to Link Gatway to Generated IP
resource "google_compute_forwarding_rule" "rule1" {
  name = "rule-1"
  region = "${substr(var.hq_zone, 0, length(var.hq_zone) - 2)}"
  ip_protocol = "ESP"
  ip_address = google_compute_address.st1.address
  target = google_compute_vpn_gateway.gateway-1.self_link
}


#UPD 500 traffic Rule
resource "google_compute_forwarding_rule" "rule2-500" {
  name = "rule-2"
  region = "${substr(var.hq_zone, 0, length(var.hq_zone) - 2)}"
  ip_protocol = "UDP"
  ip_address = google_compute_address.st1.address
  port_range = "500"
  target = google_compute_vpn_gateway.gateway-1.self_link
}


#UDP 4500 traffic rule
resource "google_compute_forwarding_rule" "rule3-4500" {
  name = "rule-3"
  region = "${substr(var.hq_zone, 0, length(var.hq_zone) - 2)}"
  ip_protocol = "UDP"
  ip_address = google_compute_address.st1.address
  port_range = "4500"
  target = google_compute_vpn_gateway.gateway-1.self_link
}


#Tunnel
resource "google_compute_vpn_tunnel" "tunnel-1" {
  name = "tunnel-hq-to-asia"
  target_vpn_gateway = google_compute_vpn_gateway.gateway-1.id
  peer_ip = google_compute_address.st2.address
  shared_secret = sensitive("secretsecret")
  ike_version = 2
  local_traffic_selector = [var.hq_ip] 
  remote_traffic_selector = [var.asia_ip]
  depends_on = [ 
    google_compute_forwarding_rule.rule1,
    google_compute_forwarding_rule.rule2-500,
    google_compute_forwarding_rule.rule3-4500
   ]
}


#Next Hop to Final Destination
resource "google_compute_route" "route1" {
  name = "route1"
  network = google_compute_network.hq_vpc.id
  dest_range = var.asia_ip
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel-1.id
  depends_on = [ google_compute_vpn_tunnel.tunnel-1 ]
}


######################## Gateway 2 - Asia ##########################################################

#Gateway
resource "google_compute_vpn_gateway" "gateway-2" {
    name = "asia-gateway"
    network = google_compute_network.asia_vpc.id
    region = "${substr(var.asia_zone, 0, length(var.asia_zone) - 2)}"
    depends_on = [ google_compute_subnetwork.asia_subnet]
}


#Static IP
resource "google_compute_address" "st2" {
  name = "asia-static-ip"
  region = "${substr(var.asia_zone, 0, length(var.asia_zone) - 2)}"
}


#Fowarding Rule to Link Gatway to Generated IP
resource "google_compute_forwarding_rule" "rule4" {
  name = "rule-4"
  region = "${substr(var.asia_zone, 0, length(var.asia_zone) - 2)}"
  ip_protocol = "ESP"
  ip_address = google_compute_address.st2.address
  target = google_compute_vpn_gateway.gateway-2.self_link
}
#>>>

#UPD 500 traffic Rule
resource "google_compute_forwarding_rule" "rule5-500" {
  name = "rule-5"
  region = "${substr(var.asia_zone, 0, length(var.asia_zone) - 2)}"
  ip_protocol = "UDP"
  ip_address = google_compute_address.st2.address
  port_range = "500"
  target = google_compute_vpn_gateway.gateway-2.self_link
}
#>>>

#UDP 4500 traffic rule
resource "google_compute_forwarding_rule" "rule6-4500" {
  name = "rule-6"
  region = "${substr(var.asia_zone, 0, length(var.asia_zone) - 2)}"
  ip_protocol = "UDP"
  ip_address = google_compute_address.st2.address
  port_range = "4500"
  target = google_compute_vpn_gateway.gateway-2.self_link
}
#>>>

#Tunnel
resource "google_compute_vpn_tunnel" "tunnel-2" {
  name = "asia-to-hq-gateway"
  target_vpn_gateway = google_compute_vpn_gateway.gateway-2.id
  peer_ip = google_compute_address.st1.address
  shared_secret = sensitive("secretsecret")
  ike_version = 2
  local_traffic_selector = [var.asia_ip] 
  remote_traffic_selector = [var.hq_ip]
  depends_on = [ 
    google_compute_forwarding_rule.rule4,
    google_compute_forwarding_rule.rule5-500,
    google_compute_forwarding_rule.rule6-4500
   ]
}


#Next Hop to Final Destination
resource "google_compute_route" "route2" {
  name = "route2"
  network = google_compute_network.asia_vpc.id
  dest_range = var.hq_ip
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel-2.id
  depends_on = [ google_compute_vpn_tunnel.tunnel-2 ]
}

############################### Peering ################################################################

resource "google_compute_network_peering" "peering_from_hq_network_to_americas_network" {
  name         = "hq-network-to-americas-network-peering"
  network      = google_compute_network.hq_vpc.self_link
  peer_network = google_compute_network.americas_vpc.self_link
}

resource "google_compute_network_peering" "peering_from_americas_network_to_hq_network" {
  name         = "americas-network-to-hq-network-peering"
  network      = google_compute_network.americas_vpc.self_link
  peer_network = google_compute_network.hq_vpc.self_link
}
