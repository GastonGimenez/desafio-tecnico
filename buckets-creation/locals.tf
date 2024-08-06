locals {
  buckets = {
    1 = {
      name = "products"
      enable_lifecycle = false
    }
    2 = {
      name = "payments"
      enable_lifecycle = true
      lifecycle_days = 30
      lifecycle_transition_days = 60
      lifecycle_storageclass = "STANDARD_IA"
    }
    3 = {
      name = "checkout"
      enable_lifecycle = false
    }
  } 
}