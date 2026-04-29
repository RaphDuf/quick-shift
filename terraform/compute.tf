# Availability Domain
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy
}

# image Ubuntu 22.04 ARM
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.tenancy
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# image Ubuntu 22.04 AMD
data "oci_core_images" "ubuntu_amd" {
  compartment_id           = var.tenancy
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}


# --- CRÉATION DES MACHINES ---

# VM Bastion/VPN (AMD - 1 OCPU / 1 Go RAM / 50 Go Disque)
resource "oci_core_instance" "vpn_bastion" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id      = var.tenancy
  display_name        = "vpn-bastion"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id        = oci_core_subnet.k3s_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_amd.images[1].id
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

# VM K3s Control Plane (Master) (ARM - 2 OCPU / 12 Go RAM / 75 Go Disque)
resource "oci_core_instance" "k3s_master" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
  compartment_id      = var.tenancy
  display_name        = "k3s-master"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.k3s_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_arm.images[2].id
    boot_volume_size_in_gbs = 75
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

# VM K3s Worker (ARM - 2 OCPU / 12 Go RAM / 75 Go Disque)
resource "oci_core_instance" "k3s_worker" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
  compartment_id      = var.tenancy
  display_name        = "k3s-worker"
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = 2
    memory_in_gbs = 12
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.k3s_subnet.id
    assign_public_ip = true
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu_arm.images[2].id
    boot_volume_size_in_gbs = 75
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}
