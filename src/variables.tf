###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

### variable "vms_ssh_root_key" {
###  type        = string
###  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMD4ql0IWWZitORgM/wqVjdHKZAhE58hG4GurVr6gTyx qshar@qsharpc03"
###  description = "ssh-keygen -t ed25519"
### }

variable "vm_web_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "ubuntu ver"
}

variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
  description = "instance name"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
  description = "Platform ID"
}

variable "vm_web_cores" {
  type = string
  default = "2"
  description = "vCPU"
}

variable "vm_web_memory" {
  type = string
  default = "1"
  description = "VM memory"
}

variable "vm_web_core_fraction" {
  type = string
  default = "5"
  description = "core fraction"
}


