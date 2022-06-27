resource "aws_ssm_association" "ssm_example" {
  name             = "AWS-ApplyAnsiblePlaybooks"
  association_name = "ssm-example-playbook"

  schedule_expression = "rate(720 minutes)"

  targets {
    key    = "InstanceIds"
    values = [ aws_instance.ssm_example.id ]
  }

  # The purpose of playbook_md5 under ExtraVariables is to trigger association run when Ansible playbook changes.
  parameters = {
    SourceType          = "S3"
    SourceInfo          = jsonencode({ "path" = "https://s3.amazonaws.com/${aws_s3_bucket.ssm_example.id}/playbook.zip "})
    InstallDependencies = "False"
    PlaybookFile        = "ssm-example.yml"
    Verbose             = "-v"
    ExtraVariables      = join(" ", [
      "aws_account_alias=${data.aws_iam_account_alias.current.account_alias}",
      "playbook_md5=${data.archive_file.ansible_playbook.output_md5}"
    ])
  }

  depends_on = [aws_s3_object.ansible_playbook]
}
