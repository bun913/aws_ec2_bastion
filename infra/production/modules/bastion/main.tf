# 最新のAmazonLinux2のAMIのIDを取得
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_iam_instance_profile" "bastion-profile" {
  name = "${var.prefix}-profile"
  role = aws_iam_role.bastion_instance_role.name
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.bastion-profile.name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  user_data              = file("${path.module}/user_data.sh")
  # NOTE: キーペアはあらかじめ作成した名前で指定が必要
  key_name = var.key_pair_name

  metadata_options {
    # NOTE: インスタンスメタデータ取得をする場合の設定(不要ならdisabledに)
    http_endpoint = "enabled"
    # IMDSv2の利用(セキュリティ強化)
    # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html
    http_tokens = "required"
  }

  tags = merge(var.tags, { Name = "${var.prefix}-bastion" })
}
