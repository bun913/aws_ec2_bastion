/*
　パッチマネージャーを使うまでに作成が必要なリソース群
　https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/sysman-patch-cliwalk.html
*/

# 今回パッチベースラインはAmazonLinux2のマネージドルールを利用
data "aws_ssm_patch_baseline" "al2" {
  owner            = "AWS"
  name_prefix      = "AWS-"
  operating_system = "AMAZON_LINUX_2"
}

resource "aws_ssm_patch_group" "main" {
  baseline_id = data.aws_ssm_patch_baseline.al2.id
  patch_group = "${var.prefix}-patchgroup"
}

resource "aws_ssm_maintenance_window" "main" {
  name     = "${var.prefix}-for-bastion"
  schedule = "rate(3 minutes)"
  duration = 2
  cutoff   = 1
}

resource "aws_ssm_maintenance_window_target" "main" {
  window_id     = aws_ssm_maintenance_window.main.id
  name          = "${var.prefix}-target1"
  description   = "Target for ${var.prefix}-bastion Tagged Instances"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Name"
    values = ["${var.prefix}-bastion"]
  }
}

resource "aws_ssm_maintenance_window_task" "main" {
  max_concurrency = 1
  max_errors      = 1
  priority        = 1
  task_arn        = "AWS-RunPatchBaseline"
  task_type       = "RUN_COMMAND"
  window_id       = aws_ssm_maintenance_window.main.id

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.main.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      /* output_s3_bucket     = aws_s3_bucket.example.bucket */
      /* output_s3_key_prefix = "output" */

      # ログをS3に出力する場合などは必要
      /* service_role_arn     = aws_iam_role.example.arn */
      timeout_seconds = 600

      /* notification_config { */
      /*   notification_arn    = aws_sns_topic.example.arn */
      /*   notification_events = ["All"] */
      /*   notification_type   = "Command" */
      /* } */

      parameter {
        name   = "Operation"
        values = ["Install"]
      }
    }
  }
}
