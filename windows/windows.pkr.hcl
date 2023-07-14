source "azure-arm" "windows-2022-trusted" {
  
  azure_tags = {
    OS = "2022x"
  }  

  #build_key_vault_name      = "kv01-packer"
  build_key_vault_sku       = "Standard"
  #build_resource_group_name = "packer"
  temp_resource_group_name  = "rg-packer-temp"
  client_id                 = "${var.CID}"
  client_secret             = "${var.CSECRET}"
  communicator              = "winrm"

  location            = "canadacentral"
  #capture_container_name = "images"
  #capture_name_prefix    = "packer"

  image_publisher     = "MicrosoftWindowsServer"
  image_offer         = "windowsserver"
  image_sku           = "2022-datacenter-azure-edition"

  os_type             = "Windows"

  secure_boot_enabled = true
  vtpm_enabled        = true

  keep_os_disk      = false
  temp_os_disk_name = "packer-temp-os-disk"

  shared_image_gallery_destination {
    subscription        = "${var.SUBSCRIPTIONID}"
    gallery_name        = "gallery_cace"
    image_name          = "Windows-Server-2022-DCATLG2"
    image_version       = "0.0.1"
    resource_group      = "packer"
    replication_regions = ["canadacentral"]
  }
  #managed_image_name = "Windows-Server-2022-DCATLG2"
  #managed_image_resource_group_name = "packer"
  subscription_id     = "${var.SUBSCRIPTIONID}"
  tenant_id           = "${var.TENANTID}"
  vm_size             = "Standard_D2as_v5"
  winrm_insecure      = true
  winrm_timeout       = "7m"
  winrm_use_ssl       = false
  winrm_username      = "packer"
}

build {
  sources = ["sources.azure-arm.windows-2022-trusted"]

  provisioner "powershell" {
    scripts = [
        "./scripts/reg.ps1",
        "./scripts/features.ps1"
    ]
  }
}
