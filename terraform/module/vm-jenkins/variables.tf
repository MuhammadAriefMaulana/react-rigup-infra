variable "name" {
  default = "mariefm" //kalau mau test2 rubah disini default=devops-telkomsel-7
}

variable "image" {
  type = string
  default = "ubuntu-2004-focal-v20210720"
}

variable "machine_type" {
  type = string
  default = "e2-medium"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "/home/muhammadmal/mariefm1.pem"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "/home/muhammadmal/mariefm1.pub"
}