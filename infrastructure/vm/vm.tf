terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.13"


  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "state-bucket-vms"
    region = "ru-central1"
    key    = "state/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}
# -------- VPC --------

resource "yandex_vpc_network" "network-kitty" {
  name = "network-kitty"
}
resource "yandex_vpc_subnet" "subnet-kitty" {
  name           = "subnet-kitty"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-kitty.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_security_group" "test-sg" {
  name        = "Kittygramm-vm-security"
  description = "Kittygramm vm security group"
  network_id  = yandex_vpc_network.network-kitty.id

  ingress {
    description       = "Allow HTTP"
    protocol          = "TCP"
    port              = 9000
    v4_cidr_blocks    = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Allow SSH"
    protocol          = "TCP"
    port              = 22
    v4_cidr_blocks    = ["0.0.0.0/0"]
  }

  egress {
    description       = "Permit ANY"
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
  }

}
# -- static ip --
resource "yandex_vpc_address" "addr" {
  name = "vm-kitty"
  deletion_protection = "false"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}
# -------- vm --------

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd8gq5886iaaakiqhsjn"
}

resource "yandex_compute_instance" "vm-kitty" {
  name        = "vm-kitty"
  hostname    = "vm-kitty"
  platform_id = "standard-v3"
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-kitty.id
    nat       = true
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
    ip_address = "192.168.10.10"
  }

  metadata = {
    user-data = file("config/vm_config.yaml")
  }
  
}

output "ip_address" {
    description = "Static IP"
    value       = yandex_compute_instance.vm-kitty.network_interface[0].nat_ip_address
}