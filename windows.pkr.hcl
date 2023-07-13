source "azure-arm" "windows-2022-trusted" {
  client_id           = ""
  client_secret       = ""
  resource_group_name = "packer"
  storage_account     = "packer-image-builder"
  subscription_id     = ""
  tenant_id           = ""

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
