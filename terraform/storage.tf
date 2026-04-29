# Récupération du namespace Object Storage
data "oci_objectstorage_namespace" "tenancy_namespace" {
  compartment_id = var.tenancy
}

# Création Bucket S3
resource "oci_objectstorage_bucket" "velero_backup" {
  compartment_id = var.tenancy
  name           = "velero-backup"
  namespace      = data.oci_objectstorage_namespace.tenancy_namespace.namespace
  access_type    = "NoPublicAccess"
  storage_tier   = "Standard"
  versioning     = "Disabled"
}

# 3Création de l'utilisateur de service et de son groupe
resource "oci_identity_user" "velero_user" {
  compartment_id = var.tenancy
  description    = "Utilisateur de service pour les backups Velero K3s"
  name           = "velero-backup-user"
  email          = "raphaeld06@hotmail.fr"
}

resource "oci_identity_group" "velero_group" {
  compartment_id = var.tenancy
  description    = "Groupe pour le service de backup Velero"
  name           = "velero-backup-group"
}

resource "oci_identity_user_group_membership" "velero_group_membership" {
  group_id = oci_identity_group.velero_group.id
  user_id  = oci_identity_user.velero_user.id
}

# Création de la Policy
resource "oci_identity_policy" "velero_policy" {
  compartment_id = var.tenancy
  description    = "Autorise Velero a gerer les objets uniquement dans son bucket"
  name           = "velero-backup-policy"

  statements = [
    "Allow group ${oci_identity_group.velero_group.name} to manage objects in tenancy where target.bucket.name='${oci_objectstorage_bucket.velero_backup.name}'"
  ]
}

# Génération des clés S3 pour l'authentification Velero
resource "oci_identity_customer_secret_key" "velero_s3_credentials" {
  display_name = "velero-s3-key"
  user_id      = oci_identity_user.velero_user.id
}
