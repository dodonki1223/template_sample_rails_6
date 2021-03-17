ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-slim-buster

# ARGに関してはdocker-compose.ymlから渡されてくる想定です
ARG PG_MAJOR
ARG NODE_MAJOR
ARG YARN_VERSION
ARG BUNDLER_VERSION

# パイプライン内のコマンドがエラーとなった時に中断するオプション
#   これがないとパイプライン時に途中で失敗しているが最後が成功しているような時は
#   成功とみなされてしまうため、この設定が必要である
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Common dependencies
# DEBIAN_FRONTEND=noninteractive
#   インストール時の対話などで処理が止まってしまう箇所をスキップしてくれる
# --no-install-recommends
#   推奨パッケージのインストールを行わなくなるので容量を節約できる
# apt-get clean 
# rm -rf /var/cache/apt/archives/*
# rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# truncate -s 0 /var/log/*log
#   特定のDockerレイヤにゴミを残さないための設定(http://docs.docker.jp/engine/userguide/storagedriver/imagesandcontainers.html#id3)
#   取得したパッケージファイルのローカルリポジトリ、インストール中に作成されたすべての
#   一時ファイルやログをクリーンアップする
# hadolint ignore=DL3008
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
# https://www.postgresql.org/download/linux/debian/
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

# Add NodeJS to sources list
# https://github.com/nodesource/distributions/blob/master/README.md#debinstall
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
# https://classic.yarnpkg.com/en/docs/install#debian-stable
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
# `.dockerdev/Aptfile` ここにインストールしたいものを書いておくことで追加でDocker内で使用できるようになる
# Aptfileを別ファイルとして切り出すことによってプロジェクトごとの依存関係を無くせる（Dockerfileの使いまわしが可能になる）
COPY .dockerdev/Aptfile /tmp/Aptfile
# hadolint ignore=SC2002,SC2046,DL3008
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$PG_MAJOR \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

# Bundler設定
# gemインストールのパスは「GEM_HOME=/bundle」で設定する
# 依存関係をホストシステムで永続化するためにボリュームとしてマウントする
# docker-compoes.ymlで設定(- bundle:/bundle)
ENV LANG=C.UTF-8\
    GEM_HOME=/bundle\
    BUNDLE_JOBS=4\
    BUNDLE_RETRY=3

# Uncomment this line if you store Bundler settings in the project's root
# BUNDLE_PATH、BUNDLE_BIN変数はgemやRuby実行ファイルを探索する場所をBundlerに伝えます
ENV BUNDLE_APP_CONFIG=$GEM_HOME\
    BUNDLE_BIN=$BUNDLE_PATH/bin

# Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
# いちいちbundle execを冒頭に付けなくてもrailsやrakeやrspecといった「binstub化されたコマンド」を実行できるようになる
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

# Upgrade RubyGems and install required Bundler version
# RubyGemsをアップグレードして必要なバージョンのBundlerをインストール
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app
