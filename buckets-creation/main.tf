module "s3-principal-buckets" {
    
    for_each = local.buckets
    
    source = "../modules/s3"

    enable_lifecycle = lookup(each.value, "enable_lifecycle", "false")
    lifecycle_ruleID = "ID-Rule-${each.key}"
    lifecycle_days = lookup(each.value, "lifecycle_days", 0)
    lifecycle_transition_days = lookup(each.value, "lifecycle_transition_days", 0)
    lifecycle_storageclass = lookup(each.value, "lifecycle_storageclass", "STANDARD")

    bucket_name = "bucket-${var.region_principal}-${var.environment}-${each.value.name}"

}

module "s3-destinations-buckets" {

    for_each = local.buckets

    source = "../modules/s3"

    enable_lifecycle = lookup(each.value, "enable_lifecycle", "false")
    lifecycle_ruleID = "ID-Rule-${each.key}"
    lifecycle_days = lookup(each.value, "lifecycle_days", 0)
    lifecycle_transition_days = lookup(each.value, "lifecycle_transition_days", 0)
    lifecycle_storageclass = lookup(each.value, "lifecycle_storageclass", "STANDARD")

    bucket_name = "bucket-${var.region_destination}-${var.environment}-${each.value.name}"
    providers = {
        aws = aws.replication
    }

}

module "replication_roles" {

    source = "../modules/IAM"

    for_each = local.buckets
    
    role_name = "s3-replication-role-${each.value.name}"
    principal_bucket_arn = module.s3-principal-buckets[each.key].bucket_arn
    replication_bucket_arn = module.s3-destinations-buckets[each.key].bucket_arn
}

resource "aws_s3_bucket_replication_configuration" "buckets_replication" {

    for_each = local.buckets

    depends_on = [module.s3-principal-buckets, module.s3-destinations-buckets]

    role = module.replication_roles[each.key].role_arn
    bucket = module.s3-principal-buckets[each.key].bucket_id
    
    rule {

        id = "replication-rule-${each.key}"
        status = "Enabled"

        filter {
            prefix = ""
        }
        delete_marker_replication {
            status = "Enabled"
        }
        existing_object_replication {
            status = "Enabled"
        }
        destination {
            bucket = module.s3-destinations-buckets[each.key].bucket_arn
            account = var.account_id
            storage_class = "STANDARD"
        }
    }
}