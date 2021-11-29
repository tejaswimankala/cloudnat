resource "google_compute_network" "vpc1" {
  name = var.network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet-1" {
  name          = "subnet-1"
  network       = google_compute_network.vpc1.name
  ip_cidr_range = "10.10.1.0/24"
  region        = "asia-east1"
}

resource "google_compute_subnetwork" "subnet-2" {
  name          = "subnet-2"
  network       = google_compute_network.vpc1.name
  ip_cidr_range = "10.10.2.0/24"
  region        = "asia-east2"
}

resource "google_compute_firewall" "allow-http" {
  name    = var.firewall
  network = google_compute_network.vpc1.name
  direction               = "INGRESS"
  priority                = 1000


  allow {
    protocol = "tcp"
    ports = ["22", "80"]
   
  }
  
  source_ranges  = ["0.0.0.0/0"]
}

resource "google_compute_instance" "instance-1" {

  name         = "instance-1"
  
  zone         = "asia-east1-b"
  machine_type = "n1-standard-1"
  tags = ["http-server"]
  
    

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }

  }

  network_interface {
    network = google_compute_network.vpc1.name
    subnetwork = google_compute_subnetwork.subnet-1.name

    access_config {

    }

  }
  metadata_startup_script = file("apache.sh")

}

resource "google_compute_instance" "instance-2" {
  name         = "instance-2"
  zone         = "asia-east2-b"
  machine_type = "n1-standard-1"
 
  
    boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }

  }

  network_interface {
    network = google_compute_network.vpc1.name
    subnetwork = google_compute_subnetwork.subnet-2.name

  }

  

}


