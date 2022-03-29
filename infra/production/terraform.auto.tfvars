vpc_cidr = "10.12.0.0/16"

public_subnets = [
  {
    "name" : "fargate-bastion-public-a",
    "az" : "ap-northeast-1a",
    "cidr" : "10.12.0.0/24"
  },
  {
    "name" : "fargate-bastion-public-c",
    "az" : "ap-northeast-1c",
    "cidr" : "10.12.1.0/24"
  },
]

private_subnets = [
  {
    "name" : "fargate-bastion-private-a",
    "az" : "ap-northeast-1a",
    "cidr" : "10.12.10.0/24"
  },
  {
    "name" : "fargate-bastion-private-c",
    "az" : "ap-northeast-1c",
    "cidr" : "10.12.11.0/24"
  },
]

db_subnets = [
  {
    "name" : "fargate-bastion-db-a",
    "az" : "ap-northeast-1a",
    "cidr" : "10.12.20.0/24"
  },
  {
    "name" : "fargate-bastion-db-c",
    "az" : "ap-northeast-1c",
    "cidr" : "10.12.21.0/24"
  },
]
# TODO: あらかじめ作成したキーペアの名前を指定する
# key_pair_name = "hoge"
# PatchManagerのためにインターネットへの出口が必要なので今回は不要
/* vpc_endpoint = { */
/*   "interface" : [ */
/*     # SSMでBastionに接続するため */
/*     "com.amazonaws.ap-northeast-1.ec2messages", */
/*     "com.amazonaws.ap-northeast-1.ssm", */
/*     "com.amazonaws.ap-northeast-1.ssmmessages", */
/*   ], */
/*   "gateway" : [ */
/*     # yum経由での各種パッケージの取得に利用 */
/*     "com.amazonaws.ap-northeast-1.s3" */
/*   ] */
/* } */
