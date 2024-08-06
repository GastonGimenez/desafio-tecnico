variable "region_principal" {
  type = string

  description = "Principal region"
}

variable "region_destination" {
  type = string
  description = "Replication region"
}

variable "create_by" {
  type = string
  description = "Created By"
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "account_id" {
  type = number
  description = "Destination account ID"
}

locals {
    tags = {
        enviroment = var.environment
        createdby = var.create_by
  }
}