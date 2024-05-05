resource "google_compute_instance" "public_instance_1" {
  depends_on   = [google_compute_subnetwork.public_subnet]
  name         = "us-central1-instance-public-a"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.public_subnet.name
    access_config {
      // Empty block to assign a public IP
    }
  }
  metadata = {
    startup-script = file("script2.sh")
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  tags = ["vpc-network-http"]
  labels = {
    name = "us-central1-public-a"
  }
  lifecycle {
    create_before_destroy = true
  }
}