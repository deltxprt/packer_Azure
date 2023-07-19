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

  #image_publisher     = "MicrosoftWindowsServer"
  #image_offer         = "windowsserver"
  #image_sku           = "2022-datacenter-azure-edition"

  shared_image_gallery {
    subscription   = "${var.SUBSCRIPTIONID}"
    resource_group = "packer"
    gallery_name   = "gallery-cace"
    image_name     = "Windows-Server-2022-DCATLG2"
    image_version  = "0.0.1"
  }

  os_type             = "Windows"

  secure_boot_enabled = true
  vtpm_enabled        = true

  virtual_network_name = "vnet01-cace"
  virtual_network_subnet_name = "Default"
  virtual_network_resource_group_name = "Lab"

  keep_os_disk      = false
  temp_os_disk_name = "packer-temp-os-disk"

  shared_image_gallery_destination {
    subscription        = "${var.SUBSCRIPTIONID}"
    gallery_name        = "gallery_cace"
    image_name          = "Windows-Server-2022-DCATLG2"
    image_version       = "0.0.2"
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
  winrm_use_ssl       = true
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

  provisioner "powershell" {
    inline = [
      " # NOTE: the following *3* lines are only needed if the you have installed the Guest Agent.",
      "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",

      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}
