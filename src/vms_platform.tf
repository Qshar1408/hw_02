variable "vm_db_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "ubuntu ver"
}

variable "vm_db_name" {
  type = string
  default = "netology-develop-platform-db"
  description = "instance name"
}

variable "vm_db_platform_id" {
  type = string
  default = "standard-v1"
  description = "Platform ID"
}

variable "vms_resources" {
  description = "Resources for all vms"
  type = map(map(number))
  default = {
    vm_web_resources = {
      cores = 2
      memory = 1
      core_fraction = 5
    }
    vm_db_resources = {
      cores = 2
      memory = 2
      core_fraction = 20 
    }
  }    
}

variable "common_metadata" {
    description = "metadata for all vms"
    type = map(string)
    default = {
        serial-port-enable = "1"
        ssh-keys = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMD4ql0IWWZitORgM/wqVjdHKZAhE58hG4GurVr6gTyx qshar@qsharpc03"
    }
}

variable "default_zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


variable "vpc_name2" {
  type        = string
  default     = "develop2"
  description = "VPC network & subnet name"
}

variable "default_cidr2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}