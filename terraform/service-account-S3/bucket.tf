## bucket.tf

// variables
variable "bucket_name" {
  description = "Name for the storage bucket"
  type        = string
  default     = "bucket-for-state"
}

# Используем ключ доступа для создания бакета
resource "yandex_storage_bucket" "tf-bucket" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.static-key.secret_key

  anonymous_access_flags {
    read = false
    list = false
  }

  force_destroy = true

provisioner "local-exec" {
  command = "echo export ACCESS_KEY='${yandex_iam_service_account_static_access_key.static-key.access_key}' > ../backend/backend.tfvars"
}

provisioner "local-exec" {
  command = "echo export SECRET_KEY='${yandex_iam_service_account_static_access_key.static-key.secret_key}' >> ../backend/backend.tfvars"
}
}