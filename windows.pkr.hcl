variable "CID" {
  type      = string
  sensitive = true
}
variable "CSECRET" {
  type      = string
  sensitive = true
}
variable "TENANTID" {
  type      = string
  sensitive = true
}
variable "SUBSCRIPTIONID" {
  type      = string
  sensitive = true
}
source "azure-arm" "windows-2022-trusted" {
  client_id           = var.CID
  client_secret       = var.CSECRET
  resource_group_name = "packer"
  storage_account     = "packer-image-builder"
  subscription_id     = var.SUBSCRIPTIONID
  tenant_id           = var.TENANTID

  capture_container_name = "images"
  capture_name_prefix    = "packer"

  os_type             = "Windows"
  image_publisher     = "MicrosoftWindowsServer"
  image_offer         = "windowsserver"
  image_sku           = "2022-datacenter-azure-edition"
  location            = "canadacentral"
  vm_size             = "Standard_D2as_v5"
  secure_boot_enabled = true
  vtpm_enabled        = true

  azure_tags = {
    OS = "2022x"
  }

  Shared_Image_Gallery_Destination {
    gallery_name   = "gallery_cace"
    image_name     = "Windows-Server-2022-DCATLG2"
    image_version  = "0.0.1"
    resource_group = "packer"
    replication_regions = ["canadacentral"]
  }
}

build {
  sources = ["sources.azure-arm.windows-2022-trusted"]

  provisioner "Powershell" {
    scripts = [
        "/scripts/reg.ps1"
        "/scripts/features.ps1"
    ]
  }
}
