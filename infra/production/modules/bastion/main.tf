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
}
