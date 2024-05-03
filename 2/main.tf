# Build Resource Output file during runtime 

resource "local_file" "log" {
  content  = <<-EOT
    VPC Name: ${google_compute_network.vpc_network.name}
    Subnet IP Range: ${google_compute_subnetwork.vpc_subnet.ip_cidr_range}
    Subnet Name: ${google_compute_subnetwork.vpc_subnet.name}

    VM Internal IP: ${google_compute_instance.web_server.network_interface.0.network_ip}
    VM External IP: http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}

    VM Name: ${var.instance_name}
    
    
    Project ID: ${data.google_project.current.project_id}
    EOT
  filename = "log.txt"
  file_permission  = "0777"
  directory_permission = "0777"
}

output "web_url" {
  value = "http://${google_compute_instance.web_server.network_interface[0].access_config[0].nat_ip}"
}
