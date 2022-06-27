resource "aws_iam_role" "ssm_example" {
  name               = "${var.aws_region}-ssm-example"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ssm_example" {
  name = "${var.aws_region}-ssm-example"
  role = aws_iam_role.ssm_example.name
}

resource "aws_iam_role_policy" "ssm_example_s3_read" {
  name   = "s3-read"
  role   = aws_iam_role.ssm_example.name
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.ssm_example.arn,
          "${aws_s3_bucket.ssm_example.arn}/*"
        ]
      }
    ]
  })
}

# Overly permissive, for demo purpose only.
resource "aws_iam_role_policy_attachment" "ssm_example_ssm_core" {
  role       = aws_iam_role.ssm_example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
