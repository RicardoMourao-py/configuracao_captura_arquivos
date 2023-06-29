variable "function_name" {
  description = "A user-defined name of the function."
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}

variable "trigger_type" {
  description = "Type of trigger: google.pubsub.topic.publish, google.storage.object.finalize"
  type        = string
}

variable "trigger_resource" {
  description = "Topic or bucket thar triggers the function."
  type        = string
}

variable "service_account_email" {
  description = "Service account to be used by cloud function."
  type        = string
  default     = null
}

variable "runtime" {
  description = "The runtime in which to run the function. Required when deploying a new function, optional when updating an existing function."
  type        = string
  default     = "python39"
}

variable "entry_point" {
  description = "The name of the function (as defined in source code) that will be executed. Defaults to the resource name suffix, if not specified. For backward compatibility, if function with given name is not found, then the system will try to use function named \"function\". For Node.js this is name of a function exported by the module specified in source_location."
  type        = string
  default     = "main"
}

variable "location" {
  description = "The location of this cloud function."
  type        = string
  default     = "us-central1"
}

variable "description" {
  description = "User-provided description of a function."
  type        = string
  default     = ""
}


variable "labels" {
  description = "A set of key/value label pairs associated with this Cloud Function."
  type        = map(string)
  default     = {}
}

variable "min_instance_count" {
  description = "(Optional) The limit on the minimum number of function instances that may coexist at a given time."
  type        = number
  default     = 0
}

variable "max_instance_count" {
  description = "(Optional) The limit on the maximum number of function instances that may coexist at a given time."
  type        = number
  default     = 0
}

variable "timeout_seconds" {
  description = "(Optional) The function execution timeout. Execution is considered failed and can be terminated if the function is not completed at the end of the timeout period. Defaults to 60 seconds."
  type        = number
  default     = 540
}

variable "environment_variables" {
  description = "(Optional) Environment variables that shall be available during function execution."
  type        = map(string)
  default     = {}
}

variable "ingress_settings" {
  description = "(Optional) Available ingress settings. Defaults to \"ALLOW_ALL\" if unspecified. Default value is ALLOW_ALL. Possible values are ALLOW_ALL, ALLOW_INTERNAL_ONLY, and ALLOW_INTERNAL_AND_GCLB."
  type        = string
  default     = "ALLOW_ALL"
}

variable "available_memory" {
  description = "Total memory that cloud function can use."
  type        = number
  default     = 256
}

variable "bucket_location" {
  description = "The bucket location where the cloud function code will be stored"
  type        = string
  default     = "US"
}

variable "bucket_versioning" {
  description = "Enable the versioning on the bucket where the cloud function code will be stored"
  type        = bool
  default     = true
}

variable "bucket_storage_class" {
  description = "The bucket storage class where the cloud function code will be stored"
  type        = string
  default     = "STANDARD"
}

variable "excludes" {
  description = "Files to exclude from the cloud function src directory"
  type        = list(string)
  default     = [
    "README.md"
  ]
}
