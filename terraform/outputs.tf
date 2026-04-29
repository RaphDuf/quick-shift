# IP Bastion / VPN
output "vpn_ip" {
  description = "Adresse IP publique du serveur VPN (AMD)"
  value       = oci_core_instance.vpn_bastion.public_ip
}

# IP Master K3s
output "master_ip" {
  description = "Adresse IP publique du noeud K3s Control Plane (ARM)"
  value       = oci_core_instance.k3s_master.public_ip
}

# IP Worker K3s
output "worker_ip" {
  description = "Adresse IP publique du noeud K3s Worker (ARM)"
  value       = oci_core_instance.k3s_worker.public_ip
}

# Clé d'accès S3 pour Velero
output "velero_s3_access_key" {
  description = "Access Key S3 pour Velero"
  value       = oci_identity_customer_secret_key.velero_s3_credentials.id
}

# Clé secrète S3 pour Velero (A GARDER SECRET)
output "velero_s3_secret_key" {
  description = "Secret Key S3 pour Velero (A GARDER SECRET)"
  value       = oci_identity_customer_secret_key.velero_s3_credentials.key
  sensitive   = true # Masque la valeur lors du terraform apply
}

# Endpoint S3 pour Velero
output "velero_s3_endpoint_url" {
  description = "URL Endpoint a utiliser dans la commande d'installation de Velero"
  value       = "https://${data.oci_objectstorage_namespace.tenancy_namespace.namespace}.compat.objectstorage.${var.region}.oraclecloud.com"
}
