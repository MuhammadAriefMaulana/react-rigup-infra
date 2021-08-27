variable "name" {
  default = "mariefm" //kalau mau test2 rubah disini default=devops-telkomsel-7
}

variable "region" {
  type = string
  default = "us-west2"
}

variable "zone" {
  type = string
  default = "us-west2-a"
}

variable "service_account" {
  type = string
  default = "devops-telkomsel-7-new@group7-322208.iam.gserviceaccount.com"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "/home/muhammadmal/mariefm1.pem"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "/home/muhammadmal/mariefm1.pub"
}

variable "PATH_TO_SA_KEY" {
  default = "/home/muhammadmal/group7-322208-75e354f7f7a2.json"
  # "./creds/serviceaccount.json"
}