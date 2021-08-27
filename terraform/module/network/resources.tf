resource "google_compute_network" "devops7-vpc" {
    name = "${var.name}-vpc"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "devops7-subnet" {
    name = "${var.name}-subnet"
    ip_cidr_range = var.subnet
    region = var.region
    network = google_compute_network.devops7-vpc.self_link
}

resource "google_compute_firewall" "devops7-fw" {
  name    = "${var.name}-fw"
  network = google_compute_network.devops7-vpc.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080", "1000-2000", "3000", "3306"]
  }
}

resource "google_compute_router" "devops7-router" {
  name    = "${var.name}-router"
  region  = google_compute_subnetwork.devops7-subnet.region
  network = google_compute_network.devops7-vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "devops7-nat" {
  name                               = "${var.name}-nat"
  router                             = google_compute_router.devops7-router.name
  region                             = google_compute_router.devops7-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}