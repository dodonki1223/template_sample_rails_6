# tempalte_sample_rails_6

## 概要

Rails6アプリケーションの開発をすぐに始められるように素のRails6アプリケーションを元に自分流にカスタマイズしたものになります  
またソースコードに不必要なコメントを大量に書いているので使用する場合は適宜、削除することをオススメします

## tempalte_sample_rails_6を動かす

下記コマンドを実行します

```shell
# ソースコードをcloneする
$ git clone https://github.com/dodonki1223/template_sample_rails_6.git

# cloneしてきたtempalte_sample_rails_6ディレクトリに移動
$ cd template_sample_rails_6/

# tempalte_sample_rails_6を動かす
$ docker-compose up rails
```

こちらのURL:[http://localhost:3000/](http://localhost:3000/) にアクセスすることで動作確認できます

**Dockerがインストールされていないと動かすことはできません**

## 環境について

### バージョン情報

| ソフトウェアスタック | バージョン    |
|:---------------------|:-------------:|
| Rails                | 6.0.2.1以上   |
| Ruby                 | 2.6.5         |
| PostgreSQL           | 12            |
| Node.js              | 12            |
| Yarn                 | 12            |
| Bundler              | 2.1.2         |
| Redis                | 5.0           |

### ローカルでの開発について

基本的にDockerを使用して開発を行えるようになっているのでPCにDockerがインストールされていれば問題ないです

#### PostgreSQLへの接続情報

| DB情報       | 値            |
|:-------------|:-------------:|
| Host         | 127.0.0.1     |
| User         | root          |
| Password     |               |
| Port         | 5432          |
| DatabaseName | dev_sample_db |

### CI（継続的インテグレーション）/CD（継続的デリバリー）環境 - Lint/Test/Deploy

自動テスト、静的コード解析、WebアプリケーションのデプロイはCircleCIで実装されていてデプロイ先には**Heroku**を使用しているのでCircleCIとHerokuの設定も必要になります  
またCircleCIの通知用（デプロイの実行、完了通知）としてSlackも使用しているので自分用のWorkspaceを作成することをオススメします

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
