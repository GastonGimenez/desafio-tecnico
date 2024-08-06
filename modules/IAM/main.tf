resource "aws_iam_role" "role_replication" {
    
    name = "buckets_replication_role"
    
    assume_role_policy = jsonencode({
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "s3.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_policy" "replication_policy" {

    name = "buckets_replication_policy"

    policy = jsonencode({
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObjectVersionForReplication",
                    "s3:GetObjectVersionAcl",
                    "s3:GetObjectVersionTagging"
                ]
                Resource = [
                    "${var.principal_bucket_arn}/*"

                ]
            },
            {
                Effect = "Allow"
                Action = [
                    "s3:ListBucket"
                ]
                Resource = [
                    var.principal_bucket_arn
                ]
            },
            {
                Effect = "Allow"
                Action = [
                    "s3:ReplicateObject",
                    "s3:ReplicateDelete",
                    "s3:ReplicateTags"
                ]
                Resource = [
                    "${var.replication_bucket_arn}/*"
                ]
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "replication_policy_attach_rol" {
    role = aws_iam_role.role_replication.name
    policy_arn = aws_iam_policy.replication_policy.arn
}