terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
  backend "s3" {
    bucket         = "zeeshan-test-bucket-22222"
    key            = "terraform-backend/atlantis-test.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

variable "id_rsa_path" {
    default = "/home/atlantis/.ssh/id_rsa"
}


provider "docker" {
  host     = "ssh://ubuntu@ithut.net:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", var.id_rsa_path]
}


# Pulls the image
resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}
variable "container_name" {}
# Create a container
resource "docker_container" "nginx" {
  image   = docker_image.ubuntu.image_id
  name    = var.container_name
  command = ["sleep", "120"]
}