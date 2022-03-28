# ManagedRoleを取得
data "aws_iam_policy" "ssmManagedPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# EC2 Role
resource "aws_iam_role" "bastion_instance_role" {
  name = "${var.prefix}-bastion"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# AttachRole
resource "aws_iam_role_policy_attachment" "bastion_instance_role_attach" {
  role       = aws_iam_role.bastion_instance_role.name
  policy_arn = data.aws_iam_policy.ssmManagedPolicy.arn
}
