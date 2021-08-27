variable "name" {
  default = "mariefm" //kalau mau test2 rubah disini default=devops-telkomsel-7
}

variable "subnet" {
  type = string
  default = "10.9.0.0/16"
}

variable "region" {
  type = string
  default = "us-west2"
}
