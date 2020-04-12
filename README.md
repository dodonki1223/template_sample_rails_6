# tempalte_sample_rails_6

## 概要

Rails6アプリケーションの開発をすぐに始められるように素のRails6アプリケーションを元に自分流にカスタマイズしたものになります  
またソースコードに不必要なコメントを大量に書いているので使用する場合は適宜、削除することをオススメします

## 改修箇所

- Docker化
    - Redis、Sidekiqの導入
- DBをPostgreSQLに変更
- RSepcの導入
    - factory_botの導入（テストデータ作成ツール）
    - SimpleCovの導入（コードカバレッジ）
- Rails ERDの導入（ER図自動生成ツール）
- デバッグツールの導入（binding.pryを使用可能にする）
- 静的コード解析ツールの導入（Rubocop、Rails Best Practices、Brakeman）
- CircleCIによる自動テスト、静的コード解析、自動デプロイ（Heroku）
- Railsガイドで紹介されている [rails generate scaffold HighScore game:string score:integer](https://railsguides.jp/command_line.html#rails-generate) を叩いた状態

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

## 設定

### Heroku

Herokuを使用し簡単にWebアプリケーションをデプロイできるようにします

#### Heroku CLIのインストール

Herokuをコマンドラインから使用できるように `Heroku CLI` をインストールします  
下記コマンドを実行してインストールします

詳しくは[公式ドキュメント](https://devcenter.heroku.com/articles/heroku-cli)を参照してください

```shell
$ brew tap heroku/brew && brew install heroku
```

#### Herokuにアプリケーションを作成する

template_sample_rails_6では `Production環境` と `Development環境` を作成します  
`Production環境` と `Development環境` それぞれに自動でデプロイされる仕組みがCircleCIに組み込まれています  

Production環境を作成する

```shell
# template-rails-prdの部分はアプリケーションの名前なので自由に決めてもらって構いません
$ heroku create template-rails-prd
```

Development環境を作成する

```shell
# template-rails-devの部分はアプリケーションの名前なので自由に決めてもらって構いません
$ heroku create template-rails-dev
```
![01_create_apps](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/heroku/01_create_apps.png)

[Personal apps](https://dashboard.heroku.com/apps) ページにアクセスして `Production環境` と `Development環境` がそれぞれできていればOKです

![02_created_apps](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/heroku/02_created_apps.png)

#### 手動でデプロイする

HerokuへPushする

```shell
$  git push heroku master
```

[https://dashboard.heroku.com/apps/アプリ名](https://dashboard.heroku.com/apps/アプリ名) にアクセスして下記のような表示なっていればOKです

![03_deployed_app](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/heroku/03_deployed_app.png)

Pushしたアプリケーションのマイグレーションを実行する

```shell
$ heroku run bin/rake db:migrate
```

Webアプリケーションがデプロイされたか確認する

```shell
$ heroku open
```

下記のように表示されていればで手動デプロイ完了です

![04_open_app](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/heroku/04_open_app.png)

### Slack

![01_notify_sample](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/01_notify_sample.png)

CircleCIで `デプロイ承認通知` と `デプロイ完了通知` を行うために自分専用のワークスペースを作成し設定します  
ワークスペースは作成してあることを前提に進みます

#### Incoming Webhookをインストール

[https://ワークスペース名.slack.com/apps](https://ワークスペース名.slack.com/apps) にアクセスし `webhook` と入力します  
検索のリストに出てきた `Incoming Webhook` をクリックします

![02_search_incoming_webhook](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/02_search_incoming_webhook.png)

`Slackに追加` をクリックします

![03_add_slack](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/03_add_slack.png)

`通知させるチャンネル` を選択し `Incoming Webhook インテグレーションの追加` をクリックします  
このサンプルでは `general` チャンネルに通知されるように設定しています

![04_select_channel](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/04_select_channel.png)

詳細の設定画面では 名前とアイコンをカスタマイズすることでなんの通知かわかりやすくなるので設定しておきましょう

![05_customize_name_and_icon](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/05_customize_name_and_icon.png)

`設定を保存する` をクリックして下記の画面になれば大丈夫です

![06_setting_end](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/06_setting_end.png)

#### スタンプを追加する

通知用にカスタム絵文字を使用するので以下の3つを追加してください  
追加する時は `カスタム絵文字を追加する` をクリックしてください

- :circleci-fail:
- :circleci-pass:
- :github_octocat:

![07_custom_emoji](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/slack/07_cutom_emoji.png)

- GitHubのアイコンは[こちらから](https://github.com/logos)ダウンロードできます
- CircleCIのアイコンは[メール通知](https://circleci.com/docs/ja/2.0/notifications/#%E3%83%A1%E3%83%BC%E3%83%AB%E9%80%9A%E7%9F%A5%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%A8%E5%A4%89%E6%9B%B4)のものを使用すると良いと思います

### CircleCI

CircleCIで自動テスト、静的コード解析、Webアプリケーションのデプロイをできようにするため  
CircleCIにプロジェクトの設定を行います

#### プロジェクトの設定を行う

こちらのURLに 「[https://app.circleci.com/projects/project-dashboard/github/GitHubのユーザー名](https://app.circleci.com/projects/project-dashboard/github/dodonki1223)」 アクセスし対象のプロジェクトの `Set Up Project` をクリックします

![01_set_up_project_circleci](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/01_set_up_project_circleci.png)

`Start Building` をクリックします

![02_start_building](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/02_start_building.png)

`config.yml` は既に存在しているので `Add Manually` をクリックします

![03_add_manually](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/03_add_manually.png)

`Start Building` をクリックします

![04_already_added_start_building](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/04_already_added_start_building.png)

CircleCIが実行されます。 `main` をクリックして詳細を確認します

![05_start_pipelines](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/05_start_pipelines.png)

workflowの実行状態が確認できます

![06_display_workflow](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/06_display_workflow.png)

時間が経つとworkflowが失敗することが確認できます  
これはCircleCIに環境変数など設定していないためです

![07_workflow_failed](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/07_workflow_failed.png)

#### 環境変数の設定を行う

`Project Settings` をクリックします

![08_to_project_settings](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/08_to_project_settings.png)

`Environment Variables` メニューをクリックして環境変数を設定していきます

![09_environment_variables_settings](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/09_environment_variables_settings.png)

環境変数は下記の4つの設定が必要です

| 環境変数名                  | 説明                              |
|:----------------------------|:----------------------------------|
| HEROKU_API_KEY              | HerokuのAPIキー                   |
| HEROKU_APP_NAME_DEVELOPMENT | HerokuのDevelopment環境のアプリ名 |
| HEROKU_APP_NAME_PRODUCTION  | HerokuのProduction環境のアプリ名  |
| SLACK_WEBHOOK               | SlackのWebHookのURL               |

**HEROKU_API_KEY**

[https://dashboard.heroku.com/account](https://dashboard.heroku.com/account) にアクセスしAPI Keyの `Reveal` をクリックしてAPI KeyをコピーしてCircleCIに設定してください

![10_heroku_api_key](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/10_heroku_api_key.png)

![11_heroku_api_key_setting](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/11_heroku_api_key_setting.png)

**HEROKU_APP_NAME_DEVELOPMENT、HEROKU_APP_NAME_PRODUCTION**

[https://dashboard.heroku.com/apps](https://dashboard.heroku.com/apps) にアクセスして Development環境とProduction環境のアプリ名をコピーして設定してください

![12_heroku_apps_list](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/12_heroku_apps_list.png)

![13_heroku_app_name_development_setting](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/13_heroku_app_name_development_setting.png)

![14_heroku_app_name_production_setting](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/14_heroku_app_name_production_setting.png)

**SLACK_WEBHOOK**

`Incoming Webhook` のページにアクセスし `設定を編集` をクリックします

![15_incoming_webhook](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/15_incoming_webhook.png)

編集画面の `Webhook URL` の `URLをコピーする` をクリックし環境変数に設定します

![16_slack_webhook_url](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/16_slack_webhook_url.png)

![17_slack_webhook_setting](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/17_slack_webhook_setting.png)

以下のようになっていればOKです

![18_complete_environment_variables](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/18_complete_environment_variables.png)

#### 再度実行して正しく動作することを確認する

[https://app.circleci.com/pipelines/github/GitHubのアカウント名/リポジトリ名](https://app.circleci.com/pipelines/github/GitHubのアカウント名/リポジトリ名) にアクセスします  
失敗したWorkflowをクリックします

![19_select_failed_workflow](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/19_select_failed_workflow.png)

`Rerun Workflow from Failed` をクリックして失敗した箇所から再度実行します

![20_rerun_workflow_from_failed](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/20_rerun_workflow_from_failed.png)

再度実行するとSlackにApprove通知が来るので `Visit Workflow` をクリックします

![21_notify_approve_for_slack](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/21_notify_approve_for_slack.png)

Workflowへ飛ぶので 停止中の `approval-job` をクリックします  
もし処理を続行させたくない場合は `Rerun` のところから `Cancel Workflow` をクリックすることで処理を終了させることができます

![22_click_approve_job](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/22_click_approve_job.png)

`Approve` をクリックし処理を続行させます

![23_approve_job](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/23_approve_job.png)

デプロイが完了するとSlackにデプロイ完了通知が来ます  
これで自動デプロイ完了です

![24_deploy_complete](https://raw.githubusercontent.com/dodonki1223/image_garage/master/template_sample_rails6/circleci/24_deploy_complete.png)

## 開発

開発環境にはRails以外にもRedisやSidekiq、Webpackerが導入されています  
起動方法やコマンドの実行方法を解説します

### Railsを起動する

```shell
$ docker-compose up rails
```

※`PostgreSQL` 、 `Redis` も一緒に起動します

### Webpackerを起動する

```shell
$ docker-compose up webpacker
```

### Sidekiqを起動する

```shell
$ docker-compose up sidekiq
```

### Runnerを起動する

Runnerはコマンドを実行するためのサービスになります  
rakeコマンドやRSpecを実行するために使用します

```shell
$ docker-compose run runner
```

以下の説明は `docker-compose run runner` 実行後の説明になります

#### RSpecを実行する

起動後のRunnerはデフォルトだと `RAILS_ENV=development` になっているためコマンドで明示的に `RAILS_ENV=test` を指定して実行します

```shell
# bundle exec ありバージョン
$ RAILS_ENV=test bundle exec rspec --format progress

# bundle exec なしバージョン
$ RAILS_ENV=test rspec --format progress
```

#### RuboCopを実行する

```shell
# bundle exec ありバージョン
$ bundle exec rubocop --require rubocop-rspec -D -P

# bundle exec なしバージョン
$ rubocop --require rubocop-rspec -D -P
```

#### Rails Best Practicesを実行する

```shell
# bundle exec ありバージョン
$ bundle exec rails_best_practices .

# bundle exec なしバージョン
$ rails_best_practices .
```

#### Brakemanを実行する

```shell
# bundle exec ありバージョン
$ bundle exec brakeman

# bundle exec なしバージョン
$ brakeman
```

#### rakeコマンドを実行する

```shell
# bin/ ありバージョン
$ bin/rake about

# bin/ なしバージョン
$ rake about
```

#### railsコマンドを実行する

```shell
# bin/ ありバージョン
$ bin/rails g --help

# bin/ なしバージョン
$ rails g --help
```

#### DBに接続する

```shell
# bin/ ありバージョン
$ bin/rails dbconsole

# bin/ なしバージョン
$ rails dbconsole
```

### その他

開発時のTipsを紹介します  
やってもやらなくても良いです

#### GitHooksのpre-pushを使用する

[pre-push](https://githooks.com/)を使用してmaster、developmentブランチにpushする前に静的コード解析を実行してCIで落ちないようにします  
CIの静的コード解析で落ちて修正するのは時間がかかるのでpush前に検知できた方が良いと思います  
ローカルのgitを使用しているのでDockerで開発しているのにローカルの環境も整える必要があり２重管理になってしまうところが悩みどころです……

pre-pushファイルを動作させるためにテンプレートファイルをコピーする

```shell
$ cp .github/hooks/pre-push .git/hooks/pre-push
```

pre-pushのファイルに実行権限ないとhookされないので実行権限を与えてやる

```shell
$ chmod 755 .git/hooks/pre-push
```

## 解説

### Docker

Docker環境に関しては以下の記事とリポジトリを参考に作成しました。ほとんどが以下の記事を真似ているので違う箇所と説明が足りない部分だけ解説します  
まずは翻訳された記事から読むと良いでしょう（原文だとdocker-compose.ymlのバージョンが古くてハマります）

- [Ruby on Whales: Dockerizing Ruby and Rails development](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
- [クジラに乗ったRuby: Evil Martians流Docker+Ruby/Rails開発環境構築（翻訳）](https://techracho.bpsinc.jp/hachi8833/2019_09_06/79035)
- [terraforming-rails/examples/dockerdev](https://github.com/evilmartians/terraforming-rails/tree/master/examples/dockerdev)

#### Dockerfile

[Dockerfile](https://github.com/dodonki1223/template_sample_rails_6/blob/master/.dockerdev/Dockerfile)はほぼ一緒だと思います

#### docker-compose.yml

[docker-compose.yml](https://github.com/dodonki1223/template_sample_rails_6/blob/master/docker-compose.yml)は変更しているので説明します  

**サービスの一覧**

サービス自体は参考した記事とリポジトリと一緒のような構成になっています

| サービス名  | 概要                                                               |
|:-----------:|:-------------------------------------------------------------------|
| rails       | Railsアプリを動かすためのサービス                                  |
| runner      | Railsと同じ環境でRailsアプリのコマンドを実行するためのサービス     |
| sidekiq     | バックグラウンドジョブを実行するためのサービス                     |
| redis       | インメモリデータベースサービス                                     |
| webpacker   | Rubyでwebpackを使用できるサービス（JavaScriptモジュールバンドラー）|
| postgres    | リレーショナルデータベースサービス                                 |

**共通化**

[extension-fields(Version3.4からの機能)](https://docs.docker.com/compose/compose-file/#extension-fields)を使用してservicesを共通化しています

| 共通名            | 概要                                                                     |
|:-----------------:|:-------------------------------------------------------------------------|
| x-app             | Dockerfileで定義したアプリケーションコンテナの構築で必要な情報を提供する |
| x-backend-volumes | Rubyのサービスで共有するボリュームを提供する                             |
| x-backend         | Rubyのサービスで共有する振る舞いを提供する                               |

**rails**

railsサービスの実行時には以下のコマンドを実行します  
何も考えずにRailsが実行できるようにしています  

```shell
# Gemのインストール
$ bundle install
# package.json にリスト化されている全ての依存関係を node_modules 内にインストールします
$ yarn install --check-files
# DBの作成＆マイグレーションを実行
$ bin/rake db:create
$ bin/rake db:migrate
# `A server is already running` の回避
$ rm -f tmp/pids/server.pid
# Railsを実行
$ bundle exec rails server -b 0.0.0.0
```

下記コマンドに関しては初回起動時だけ必要なコマンドなので削除しても良いでしょう

```shell
$ bin/rake db:create
```

**postgres**

`bin/rake db:create` を実行すると下記のようなエラーが出ます

```
FATAL:  role "root" does not exist
Couldn't create 'test_eroge_release' database. Please check your configuration.
rake aborted!
PG::ConnectionBad: FATAL:  role "root" does not exist
```

エラーを出さないために予め `root` ユーザーを作成して置く必要があります  
下記のSQLは [postgres - Docker Hub](https://hub.docker.com/_/postgres)の `Initialization scripts` の項目を参考に起動時に実行されるように設定しています

```sql
-- rootユーザーを作成する
CREATE USER root WITH SUPERUSER;
-- root ROLEはログイン可能にする
ALTER ROLE root LOGIN;
```

**Docker高速化**

`:cached` を使用しDocker for Macでホストのディレクトリをマウントした時の遅さを回避しています  
`:cached` 設定はコンテナで実行された書き込みはホストにすぐに反映されるがホストで実行された書き込みは遅延が生じる可能性がある

詳しくは以下の記事を読むと良いでしょう

- [Performance tuning for volume mounts (shared filesystems)](https://docs.docker.com/docker-for-mac/osxfs-caching/#cached)
- [User-guided caching in Docker for Mac](https://www.docker.com/blog/user-guided-caching-in-docker-for-mac/)

```yml
x-backend-volumes: &backend-volumes
  volumes:
    - .:/app:cached
```

永続化データはホストでマウントせずに [Volumes](https://docs.docker.com/storage/volumes/) を使用することにより遅さを回避

```yml
x-backend-volumes: &backend-volumes
  volumes:
    - bundle:/bundle
    - rails_cache:/app/tmp/cache
    - node_modules:/app/node_modules
    - packs:/app/public/packs
```
