############################## Gateway 1 ##########################################################
resource "google_compute_vpn_gateway" "gateway-1" {
    name = "lunar-gateway1"
    network = google_compute_network.network_1.id
    region = var.net1_sub2_region
    depends_on = [ google_compute_subnetwork.network_sub2 ]
}


#Static IP
resource "google_compute_address" "st1" {
  name = "orbit1"
  region = var.net1_sub2_region
}


#Fowarding Rule to Link Gatway to Generated IP
resource "google_compute_forwarding_rule" "rule1" {
  name = "rule-1"
  region = var.net1_sub2_region
  ip_protocol = "ESP"
  ip_address = google_compute_address.st1.address
  target = google_compute_vpn_gateway.gateway-1.self_link
}


#UPD 500 traffic Rule
resource "google_compute_forwarding_rule" "rule2-500" {
  name = "rule-2"
  region = var.net1_sub2_region
  ip_protocol = "UDP"
  ip_address = google_compute_address.st1.address
  port_range = "500"
  target = google_compute_vpn_gateway.gateway-1.self_link
}


#UDP 4500 traffic rule
resource "google_compute_forwarding_rule" "rule3-4500" {
  name = "rule-3"
  region = var.net1_sub2_region
  ip_protocol = "UDP"
  ip_address = google_compute_address.st1.address
  port_range = "4500"
  target = google_compute_vpn_gateway.gateway-1.self_link
}


#Tunnel
resource "google_compute_vpn_tunnel" "tunnel-1" {
  name = "highliner1"
  target_vpn_gateway = google_compute_vpn_gateway.gateway-1.id
  peer_ip = google_compute_address.st2.address
  shared_secret = sensitive("faquettetuseifraise")
  ike_version = 2
  local_traffic_selector = [var.net1_sub2_iprange] 
  remote_traffic_selector = [var.net2_sub1_iprange]
  depends_on = [ 
    google_compute_forwarding_rule.rule1,
    google_compute_forwarding_rule.rule2-500,
    google_compute_forwarding_rule.rule3-4500
   ]
}


#Next Hop to Final Destination
resource "google_compute_route" "route1" {
  name = "route1"
  network = google_compute_network.network_1.id
  dest_range = var.net2_sub1_iprange
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel-1.id
  depends_on = [ google_compute_vpn_tunnel.tunnel-1 ]
}


######################## Gateway 2 ##########################################################

#Gateway
resource "google_compute_vpn_gateway" "gateway-2" {
    name = "lunar-gateway2"
    network = google_compute_network.network_2.id
    region = var.net2_sub1_region
    depends_on = [ google_compute_subnetwork.network2_sub1]
}
#>>>

#Static IP
resource "google_compute_address" "st2" {
  name = "orbit2"
  region = var.net2_sub1_region
}


#Fowarding Rule to Link Gatway to Generated IP
resource "google_compute_forwarding_rule" "rule4" {
  name = "rule-4"
  region = var.net2_sub1_region
  ip_protocol = "ESP"
  ip_address = google_compute_address.st2.address
  target = google_compute_vpn_gateway.gateway-2.self_link
}
#>>>

#UPD 500 traffic Rule
resource "google_compute_forwarding_rule" "rule5-500" {
  name = "rule-5"
  region = var.net2_sub1_region
  ip_protocol = "UDP"
  ip_address = google_compute_address.st2.address
  port_range = "500"
  target = google_compute_vpn_gateway.gateway-2.self_link
}
#>>>

#UDP 4500 traffic rule
resource "google_compute_forwarding_rule" "rule6-4500" {
  name = "rule-6"
  region = var.net2_sub1_region
  ip_protocol = "UDP"
  ip_address = google_compute_address.st2.address
  port_range = "4500"
  target = google_compute_vpn_gateway.gateway-2.self_link
}
#>>>

#Tunnel
resource "google_compute_vpn_tunnel" "tunnel-2" {
  name = "highliner2"
  target_vpn_gateway = google_compute_vpn_gateway.gateway-2.id
  peer_ip = google_compute_address.st1.address
  shared_secret = sensitive("faquettetuseifraise")
  ike_version = 2
  local_traffic_selector = [var.net2_sub1_iprange] 
  remote_traffic_selector = [var.net1_sub2_iprange]
  depends_on = [ 
    google_compute_forwarding_rule.rule4,
    google_compute_forwarding_rule.rule5-500,
    google_compute_forwarding_rule.rule6-4500
   ]
}
#>>>

#Next Hop to Final Destination
resource "google_compute_route" "route2" {
  name = "route2"
  network = google_compute_network.network_2.id
  dest_range = var.net1_sub2_iprange
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel-2.id
  depends_on = [ google_compute_vpn_tunnel.tunnel-2 ]
}
