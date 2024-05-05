# Build Resource Output file during runtime 

resource "local_file" "log" {
  content  = <<-EOT
    Headquarters:
    VPC Name: ${google_compute_network.hq_vpc.name}
    
    Subnet IP Range: ${google_compute_subnetwork.hq_subnet.ip_cidr_range}
    Subnet Name: ${google_compute_subnetwork.hq_subnet.name}
    
    VM Internal IP: ${google_compute_instance.web_server.network_interface.0.network_ip}
    VM External IP: http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}

    Americas:
    VPC Name: ${google_compute_network.americas_vpc.name}
    
    Subnet 1 IP Range: ${google_compute_subnetwork.americas_subnet1.ip_cidr_range}
    Subnet 2 IP Range: ${google_compute_subnetwork.americas_subnet2.ip_cidr_range}
    Subnet 1 Name: ${google_compute_subnetwork.americas_subnet1.region}
    Subnet 2 Name: ${google_compute_subnetwork.americas_subnet2.region}
    
    VM 1 Internal IP: ${google_compute_instance.americas_server1.network_interface.0.network_ip}
    VM 1 External IP: http://${google_compute_instance.americas_server1.network_interface[0].access_config[0].nat_ip}
    VM 2 Internal IP: ${google_compute_instance.americas_server2.network_interface.0.network_ip}
    VM 2 External IP: http://${google_compute_instance.americas_server2.network_interface[0].access_config[0].nat_ip}

    Asia:
    VPC Name: ${google_compute_network.asia_vpc.name}
    
    Subnet IP Range: ${google_compute_subnetwork.asia_subnet.ip_cidr_range}
    Subnet Name: ${google_compute_subnetwork.asia_subnet.name}
    
    VM Internal IP: ${google_compute_instance.asia_server.network_interface.0.network_ip}
    VM External IP: http://${google_compute_instance.asia_server.network_interface[0].access_config[0].nat_ip}
    EOT
  filename = "log.txt"
  file_permission  = "0777"
  directory_permission = "0777"
}

