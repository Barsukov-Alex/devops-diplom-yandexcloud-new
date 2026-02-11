// Создание сервисного аккаунта
resource "yandex_iam_service_account" "terraform" {
  name        = "terraform"
  folder_id   = var.folder_id
  description = "SA for terraform"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "static-key" {
  service_account_id = yandex_iam_service_account.terraform.id
  description        = "static access key for object storage"
}