resource "google_cloudfunctions_function" "this" {
  name        = var.function_name
  region      = var.location
  description = var.description
  project     = var.project
  labels      = var.labels

  runtime     = var.runtime
  entry_point = var.entry_point

  source_archive_bucket = google_storage_bucket.this.id
  source_archive_object = google_storage_bucket_object.this.name

  min_instances             = var.min_instance_count
  max_instances             = var.max_instance_count
  timeout                   = var.timeout_seconds
  environment_variables     = var.environment_variables
  ingress_settings          = var.ingress_settings
  available_memory_mb       = var.available_memory
  service_account_email     = var.service_account_email
  
  event_trigger {
    event_type   = var.trigger_type
    resource     = var.trigger_resource
  }
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/.terraform_tmp/${var.function_name}.zip"
  source_dir  = "${path.module}/../src"
  excludes    = var.excludes
}

resource "google_storage_bucket" "this" {
  name = "${var.project}_${var.function_name}"
  project = var.project
  location = var.bucket_location
  force_destroy = true
  uniform_bucket_level_access = true
  storage_class = var.bucket_storage_class

  versioning {
    enabled = var.bucket_versioning
  }
}

resource "google_storage_bucket_object" "this" {
  name   = "${var.function_name}.${data.archive_file.this.output_sha}.zip"
  bucket = google_storage_bucket.this.id
  source = data.archive_file.this.output_path
}
