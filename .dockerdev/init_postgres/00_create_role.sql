-- rootユーザーを作成しておかないと `bin/rake db:create` コマンドで落ちる
-- `bin/rake db:create` コマンドを実行するために予めrootユーザーを作成しておくようにする
-- `bin/rake db:create` コマンドを実行してでるエラーは下記のような感じです
--   FATAL:  role "root" does not exist
--   Couldn't create 'test_eroge_release' database. Please check your configuration.
--   rake aborted!
--   PG::ConnectionBad: FATAL:  role "root" does not exist
-- 参考記事として以下を確認すると良い
--   https://stackoverflow.com/questions/27225524/fatal-role-root-does-not-exist
--   https://github.com/Shippable/support/issues/4018
--   他の対応策として `bin/rake db:create` コマンドを実行する前に下記コマンドを実行するのもあり
--     psql -c 'CREATE USER root WITH SUPERUSER;ALTER ROLE root LOGIN' -U postgres -h postgres

-- rootユーザーを作成する
CREATE USER root WITH SUPERUSER;

-- root ROLEはログイン可能にする
ALTER ROLE root LOGIN;
