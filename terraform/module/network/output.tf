output "vpc_id" {
  value = google_compute_network.devops7-vpc.id
}
output "subnet_id" {
  value = google_compute_subnetwork.devops7-subnet.id
}
output "cidr_block" {
  value = var.subnet
}

