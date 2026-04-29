# VCN
resource "oci_core_vcn" "k3s_vcn" {
  compartment_id = var.tenancy
  cidr_block     = "10.0.0.0/16"
  display_name   = "k3s-vcn"
  dns_label      = "k3svcn"
}

# passerelle Internet
resource "oci_core_internet_gateway" "k3s_igw" {
  compartment_id = var.tenancy
  vcn_id         = oci_core_vcn.k3s_vcn.id
  display_name   = "k3s-igw"
}

# table de routage
resource "oci_core_route_table" "k3s_rt" {
  compartment_id = var.tenancy
  vcn_id         = oci_core_vcn.k3s_vcn.id
  display_name   = "k3s-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.k3s_igw.id
  }
}

# Security List
resource "oci_core_security_list" "k3s_sl" {
  compartment_id = var.tenancy
  vcn_id         = oci_core_vcn.k3s_vcn.id
  display_name   = "k3s-security-list"

  # all trafic sortant 
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # trafic interne VMs 
  ingress_security_rules {
    protocol = "all"
    source   = "10.0.0.0/16"
  }

  # SSH
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # HTTP
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS 
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # WireGuard VPN
  ingress_security_rules {
    protocol = "17" # UDP
    source   = "0.0.0.0/0"
    udp_options {
      min = 51820
      max = 51820
    }
  }
}

# Subnet
resource "oci_core_subnet" "k3s_subnet" {
  compartment_id    = var.tenancy
  vcn_id            = oci_core_vcn.k3s_vcn.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "k3s-subnet"
  route_table_id    = oci_core_route_table.k3s_rt.id
  security_list_ids = [oci_core_security_list.k3s_sl.id]
  dns_label         = "k3ssubnet"
}
