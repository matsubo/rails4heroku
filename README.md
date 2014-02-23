Rails4をherokuで公開する方法
====

最終更新日：2013/2/23

概要
---
現在最新のRuby on Rails 4.0.3をherokuで公開するための設定を記載します。
大きく、2つの項目で構成されます。
- 0からのゼットアップ
- このサンプルコードを使って動かす


要件
---
以下のツールがセットアップされている前提です。

- git
- Heroku Toolbelt
- Ruby 1.9~ or 2.0~
- bundler


0からセットアップ
---

### Railsプロジェクトの作成

- Railsのプロジェクトを作成する段階から解説します。
- ここでは、`rails4heroku`というプロジェクト名にし、同じくheroku上にも`rails4heroku`という名前のアプリケーションを作成します。
  - 同一にする必要はありません。
- Macでのコマンドラインを操作する前提で記載しています。同様の操作をGUIで行っても問題ありません。


railsのプロジェクトを作成し、そのディレクトリに入ります。
```
% rails new rails4heroku
% cd  rails4heroku
```

gitに初期状態を登録しておきます。
```
% git init
% git add .
% git commit -m 'created project'
```


### Railsの設定変更

Railsのデフォルトでは、データベースエンジンがSQLiteになっていますが、[herokuでは利用出来ません](https://devcenter.heroku.com/articles/sqlite3)。その代わり、PostgreSQLというデータベースが利用出来るようになっています。

次に、SQLiteを本番で利用しないようにする設定を行うために、Gemfileを開きます。
```
% vi Gemfile
```

こちらのURLの内容にある差分を参考に、sqlite3を削除し、数行を追加します。

- https://github.com/matsubo/rails4heroku/commit/4e72700bacbb26624dc9a2ed63a2a8dea3b01b5c


変更が終わったら、gitにコミットしておきます。
```
% g commit -a -m 'Disabled sqlite3 on production'
```


必要に応じて、Railsのサーバで静的ファイルを配信できるようにしておきます。production環境では、デフォルトでは静的ファイルは配信できないようになっています。

まず、`config/environments/production.rb`を開きます。
```
% vi config/environments/production.rb
```

こちらのURLを参考に、`config.serve_static_assets`をtrueにしておきます。

- https://github.com/matsubo/rails4heroku/commit/43e2ab326657a70f4b2563cd673b9a878a391a82```


念のため、gitにコミットしておきます。
```
% g commit -a -m 'enabled static asset distribution'
```

この状態でもアプリケーションは動くのですが、普通のアプリケーションはデータベースを利用していると思うので、適当にscaffoldを使ってアプリケーションを作っておきます。

```
% rails g scaffold todos name:string
% rake db:migrate 
```

また、トップページにアクセスしたときに、今作ったアプリケーションのindexが表示されるように、`config/routes.rb`を変更します。
- https://github.com/matsubo/rails4heroku/commit/53f5639a0cda6c4f28b21f8a4f67779ddefb2901

```
% vi config/routes.rb
```


念のため、ローカルで動作確認を行います。
```
% rails s
```

これにてソースコードの変更は終わりなので、gitにコミットします。
```
% g add .
% git commit -a -m 'Created todo application'
```


### Herokuのセットアップ

heroku上にアプリケーションを作成します。ここでは、`rails4heroku`という名前にします。

```
% heroku create rails4heroku
```

次に、PostgreSQLを利用するために、herokuのaddonを追加します。
```
% heroku addons:add heroku-postgresql:dev
```

herokuへpushします。
```
% git push heroku master
```

pushが成功したら、heroku上でmigrateを行います。
```
% heroku run rake db:migrate
```

これで、アプリケーションがWebから見られる状態になたので、ブラウザで動作確認をしてみます。

URLのサブドメイン名は各自が作成したアプリケーション名になります。
- http://rails4heroku.herokuapp.com/


もし、アプリケーションが動作しない場合配下のコマンドでheroku上のエラーログをリアルタイムに確認出来ます。

```
% heroku  logs --tail
```




サンプルコード使って動かす
---

このサンプルコードを使って、簡単に試してみる場合は以下のコマンドを順番に行えば出来ます。
`appname`の部分は、自分で置き換えてください。

```
% git clone git@github.com:matsubo/rails4heroku.git
% heroku create appname
% heroku addons:add heroku-postgresql:dev
% git push heroku master
% heroku run rake db:migrate
```

ブラウザで確認する
- http://appname.herokuapp.com/



