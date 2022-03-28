# FargateによるBastion(踏み台ホスト)の構築

## 　構成

踏み台を構成するにあたり、以下2パターンを検討。

今回は構成1をTerraformで実装します。

### 構成1

別リポジトリで実装。

Fargateタスクを利用する、できればこちらを使いたいパターン。

https://github.com/bun913/aws_fargate_bastion

### 構成2

今回活用するパターン

EC2インスタンスを作成して、キーペアはあらかじめローカルPCで作成しておく。

キーペアの秘密鍵はSecretsManagerで管理して、各開発者に配布する。

WIP: 構成図

この構成のメリット

- SSM SessionManagerでsshポートを開けずに、プライベートサブネットのEC2にセキュアに接続できる
- SessionManagerでSSHセッションを開始できるので、SSHトンネリングでDBクライアント経由でRDSにアクセスしたい場合にも簡単
  - FargateのBastionではこちらが面倒

この構成のデメリット

- EC2を立てるので、Fargateに比べたら管理する範囲が広くなる
  - OSもシステム管理者側で管理しないといけなくなる・・

DBクライアントを使う必要がない場合などは、素直に構成1を使った方が良さそう。

【参考】

https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html

## 手順

### 事前準備

### globalリソース群の作成

今回はECRを作成して、イメージのプッシュまで行う。

```bash
cd infra/global
terraform init
terraform plan
terraform apply
```

### productionリソース群の作成

今回は本番環境を想定して、productionというディレクトリ名にしている。
（他、developmentやstagingなど環境ごとに作成されるイメージ)


```bash
cd ../production
terraform init
terraform plan
terraform apply
```

## ローカルからの実行

```bash
# タスクをCLIで起動
 ./run_task.sh prd
# task_idが出力されればOK
# 出力されたタスクIDを第2引数に渡す
./ecs_exec.sh prd ${TASKのID}
```

以下のように出力されればセッション開始

```
The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.
Starting session with SessionId: ecs-execute-command-
```

RDSに接続する場合は、以下のようにシェルスクリプトを実行する

```bash
mysql -h ${RDSのライターのエンドポイント} -u root -p
> Terraformで設定したパスワードを入力する
```

