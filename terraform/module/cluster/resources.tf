module "networkModule" {
  source = "../network"
}

resource "google_container_cluster" "devops7-cluster" {
  name               = var.name
  location           = var.zone
  initial_node_count = 2
  network = module.networkModule.vpc_id
  subnetwork = module.networkModule.subnet_id

  //activate IP aliases
  ip_allocation_policy {
    //cluster_secondary_range_name  = var.cluster_secondary_range_name
    //services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block = "172.17.0.0/28"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = module.networkModule.cidr_block
      display_name = "devops7-authorized-network"
    }
  }
  node_config {
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  //  labels = {
  //    foo = "bar"
  //  }
  //  tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}