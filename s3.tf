resource "aws_s3_bucket" "ssm_example" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.aws_region}-ssm-example"
}

resource "aws_s3_bucket_acl" "ssm_example" {
  bucket = aws_s3_bucket.ssm_example.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "ssm_example" {
  bucket                  = aws_s3_bucket.ssm_example.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ssm_example" {
  bucket = aws_s3_bucket.ssm_example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "ssm_example" {
  bucket = aws_s3_bucket.ssm_example.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "enforce_secure_transport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          aws_s3_bucket.ssm_example.arn,
          "${aws_s3_bucket.ssm_example.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

data "archive_file" "ansible_playbook" {
  type        = "zip"
  source_dir  = "${path.root}/ansible/playbook"
  output_path = "${path.root}/ansible/playbook.zip"
}

resource "aws_s3_object" "ansible_playbook" {
  bucket = aws_s3_bucket.ssm_example.id
  key    = "playbook.zip"
  source = "${path.root}/ansible/playbook.zip"

  etag = data.archive_file.ansible_playbook.output_md5
}

locals {
  ansible_vars = <<-EOT
  var_file_example: 'vars_from_file'
  EOT
}

resource "aws_s3_object" "ansible_vars" {
  bucket  = aws_s3_bucket.ssm_example.id
  key     = "ansible_vars.yml"
  content = local.ansible_vars

  etag = md5(local.ansible_vars)
}
