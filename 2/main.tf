# Build Resource Output file during runtime 

resource "local_file" "log" {
  content  = <<-EOT
    VPC Name: ${google_compute_network.vpc_network.name}
    Subnet IP Range: ${google_compute_subnetwork.public_subnet.ip_cidr_range}
    Subnet Name: ${google_compute_subnetwork.public_subnet.name}

    VM Internal IP: ${google_compute_instance.public_instance_1.network_interface.0.network_ip}
    VM External IP: http://${google_compute_instance.public_instance_1.network_interface[0].access_config[0].nat_ip}

    VM Name: ${google_compute_instance.public_instance_1.name}
    
    
    Project ID: ${data.google_project.current.project_id}
    EOT
  filename = "log.txt"
  file_permission  = "0777"
  directory_permission = "0777"
}


output "web_url" {
  value = "http://${google_compute_instance.public_instance_1.network_interface[0].access_config[0].nat_ip}"
}
