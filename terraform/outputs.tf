output "id" {
  description = "An identifier for the resource with format `projects/{{project}}/locations/{{location}}/functions/{{name}}`"
  value       = google_cloudfunctions_function.this.id
}

output "url" {
  description = "The url to reach the function"
  value       = google_cloudfunctions_function.this.https_trigger_url
}
