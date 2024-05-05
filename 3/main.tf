# main.tf 

# Create a VM instance for HQ
resource "google_compute_instance" "web_server" {
  machine_type = "e2-medium"
  
  
  name = var.hq_instance_name
  zone = var.hq_zone
  metadata = {
    startup-script = file("startup-script.sh")
}
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  
  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    subnetwork = google_compute_subnetwork.hq_subnet.self_link
    network = google_compute_network.hq_vpc.self_link
  }

   
}



################################## VM for Asia ##################################################


resource "google_compute_instance" "asia_server" {
  machine_type = "e2-medium"
  
  
  name = var.asia_instance_name
  zone = var.asia_zone

  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
    }
  }
 
  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    subnetwork = google_compute_subnetwork.asia_subnet.self_link
    network = google_compute_network.asia_vpc.name
  }

   
}

#############################  VM for Americas ############################################


resource "google_compute_instance" "americas_server1" {
  machine_type = "e2-medium"
  
  
  name = var.americas_instance_name
  zone = var.americas_zone

  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
    }
  }

  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    subnetwork = google_compute_subnetwork.americas_subnet1.self_link
    network = google_compute_network.americas_vpc.self_link
  }

   
}

resource "google_compute_instance" "americas_server2" {
  machine_type = "e2-medium"
  
  
  name = var.americas_instance_name2
  zone = var.americas_zone

  boot_disk {
    initialize_params {
      image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
    }
  }

  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    subnetwork = google_compute_subnetwork.americas_subnet2.self_link
    network = google_compute_network.americas_vpc.self_link
  }

   
}
