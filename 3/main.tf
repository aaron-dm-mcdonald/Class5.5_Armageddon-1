# main.tf 

# Create a VM instance
resource "google_compute_instance" "web_server" {
  machine_type = "e2-medium"
  metadata = {
    metadata_startup_script = file("script2.sh")
  }
  name = var.instance_name
  zone = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  
  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    subnetwork = google_compute_subnetwork.vpc_subnet.self_link
    network = google_compute_network.vpc_network.name
  }

   
}

# Define a template file to generate the HTML page
data "template_file" "index_html" {
  template = <<EOF
<html>
<head><title>Instance Details</title></head>
<body>
<h2>VPC Name: ${google_compute_network.vpc_network.name}</h2>
<p>Subnet IP Range: ${google_compute_subnetwork.vpc_subnet.ip_cidr_range}</p>
<p>Resource Region: ${google_compute_subnetwork.vpc_subnet.region}</p>
<p>VM Internal IP: ${google_compute_instance.web_server.network_interface.0.network_ip}</p>
<p>VM External IP: <a href="http://${google_compute_instance.web_server.network_interface.0.access_config.0.nat_ip}">${google_compute_instance.web_server.network_interface.0.access_config.0.nat_ip}</a></p>
<p>VM Name: ${var.instance_name}</p>
</body>
</html>
EOF
}

# Use a null_resource to copy the HTML file to the VM
resource "null_resource" "copy_html_to_vm" {
  triggers = {
    instance_ip = google_compute_instance.web_server.network_interface.0.access_config.0.nat_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${data.template_file.index_html.rendered}' | sudo tee /var/www/html/index.html",
    ]

    connection {
      type        = "ssh"
      user        = var.vm_ssh_username
      private_key = file(var.ssh_private_key_path)
      host        = google_compute_instance.web_server.network_interface.0.access_config.0.nat_ip
    }
  }
}
