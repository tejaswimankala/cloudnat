resource "google_compute_router" "router" {
  name    = var.router
  region  = google_compute_subnetwork.subnet-2.region
  network = google_compute_network.vpc1.name
}

resource "google_compute_address" "address" {
  name = "computeadd-p"
  region = google_compute_subnetwork.subnet-2.region
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.address.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet-2.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

