terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

variable "id_rsa_path" {
    default = "/home/atlantis/.ssh/id_rsa"
}


# resource "local_file" "id_rsa" {
#   filename = var.id_rsa_path
#   content  = var.id_rsa_data
#   file_permission = "0600"
# }

provider "docker" {
  host     = "ssh://ubuntu@ithut.net:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", var.id_rsa_path]
}


# Pulls the image
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

# Create a container
resource "docker_container" "foo" {
  image   = docker_image.ubuntu.image_id
  name    = "foo"
  command = ["sleep", "120"]
}