# bookersのテストコードを読み解いてみよう

# frozen_string_literal: true
# ↑ 文字列リテラルをfreeze（破壊的変更を防止）させています。
#   RSpecとは関係ありません。記述がなくても動作します。

require 'rails_helper'
# ↑ これはspec/rails_helper.rbを読み込んでいます。設定などを行うファイルです。

RSpec.describe Book, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:book)).to be_valid
      # ↑ FactoryBot.build(:book)で作成したBookモデルのインスタンスをexpectに渡して、be_validで有効かを判定しています。
      # ここでexpectの期待値でFactoryBot.build(:book)として使用されています。
      # FactoryBot.build(:モデル名)で対象モデルのインスタンスを作成します。
      # FactoryBotを使用すればit部などにいちいちインスタンスをnewして値を代入する必要性がなくなり、簡潔に記述することが可能です。
    end
  end
  context "空白のバリデーションチェック" do
    it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      book = Book.new(title: '', body:'hoge')
      expect(book).to be_invalid
      expect(book.errors[:title]).to include("can't be blank")
    end
    it "bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
      book = Book.new(title: 'hoge', body:'')
      expect(book).to be_invalid
      expect(book.errors[:body]).to include("can't be blank")
      # ↑ マッチャーのincludeは配列の中身に〇〇が含まれているかを判定します。
      #   今回の場合はexpectにエラーメッセージの配列を渡して、その配列の中に"can't be blank"という要素が含まれるかを判定しています。
    end
  end
end