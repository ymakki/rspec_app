# bookersのテストコードを読み解いてみよう

# FactoryBotとは

# FactoryBotはテストデータの作成をサポートするGemです。
# bookersのGemfileでgroup :test do ~ end の箇所に記載されています。

# 使用方法についてはbookersを確認しながら見ていきましょう。
# FactoryBotを使用するにはspec/factories/モデル名.rbといった形でファイルを作成します。
# bookersの場合はspec/factories/book.rbというファイル構成になっています。

# 次にテストデータの定義をコードで記述します。
# spec/factories/book.rbを確認すると以下のようになっています。

FactoryBot.define do #宣言文でありデータの定義を行う際に記述します。
  factory :book do #どのモデルに対してデータ定義を行うのか記します。factory :モデル名 do ~ end
    title { Faker::Lorem.characters(number:5) } #カラム名｛ 値 ｝の形になっています。※Fakerについては後述
    body { Faker::Lorem.characters(number:20) } #カラム名｛ 値 ｝の形になっています。
  end
end

# このようにFactoryBotではspec/factories/モデル名.rbにテストデータの定義を記述します。

# FactoryBot.build(:モデル名)で対象モデルのインスタンスを作成します。
# FactoryBotを使用すればit部などにいちいちインスタンスをnewして値を代入する必要性がなくなり、簡潔に記述することが可能です。



# Fakerとは

# Fakerとはテスト用のダミーデータを作成するためのGemです。
# bookersのGemfileでgroup :test do ~ doの箇所に記載されています。
# Fakerは様々な場面で使用されますが、bookersのテストコードの場合はFactoryBotのテストデータの定義をする中で使用されています。
# またsystem/books_spec.rbの中でフォームの入力値にもFakerが使用されています。

# spec/factories/book.rbの中で使用されているFakerの記述を確認して使い方を学びましょう。


# カラムに対しての値としてダミーデータを使用していることがわかります。

# Faker::Lorem.characters(number:5)
# この記述を分解すると以下のようになります。

# Faker:: ：Fakerを使用する時の宣言
# Lorem：ダミーテキストタイプを選択　※Lorem=lorem ipsumの略でダミーテキストの意味
# characters：文字列を作成
# number：生成文字数の指定

# ランダムな英数文字列を5文字生成するということになります。


# Fakerの補足
# Fakerで生成できるダミーデータはランダムな英数文字列だけではありません。

# 名前のようなダミーデータの生成

# Faker::Name.name      # => "Taro Yamada"

# メールアドレスのようなダミーデータ

# Faker::Internet.email # => "example@hoge.com"
# このように様々なタイプのダミーデータを作成できるため、実データに近い条件でテストを行うことが出来るようになります。