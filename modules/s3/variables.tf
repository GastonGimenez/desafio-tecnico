variable "bucket_name" {
    type = string
}

variable "enable_lifecycle" {
  type = bool
  default = false
}

variable "lifecycle_days" {
  type = number
}

variable "lifecycle_transition_days" {
  type = number
  default = 0
}

variable "lifecycle_storageclass" {
  type = string
  default = "STANDARD"
}

variable "lifecycle_ruleID" {
  type = string
  default = 0
}