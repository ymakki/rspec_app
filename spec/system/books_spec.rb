# bookersのテストコードを読み解いてみよう

require 'rails_helper'

describe '投稿のテスト' do
  let!(:book) { create(:book,title:'hoge',body:'body') }
    # ↑ データの作成を行い「book」として使用することが可能です。
    # 　letで指定されたものは遅延評価といってitの中でbookが出てきたときに始めて実行されます。
    # 　今回のlet!は事前評価といいます。beforeと似たような使われ方をされますが、beforeではitブロックの実行時に都度実行されます。
    # 　そのためit内で使用しない変数の場合にもbeforeは実行されてしまいます。

    # letとはインスタンス変数を置き換えるときに使用します。
    # このletを使用した記述の仕方は以下と似た意味を持っています。
    # before do
    #   @book = FactoryBot.create(title:'hoge',body:'body')
    # end
    # letの(:book)はインスタンス変数としての役割を持っていることになります。
  describe 'トップ画面(root_path)のテスト' do
    before do
      visit root_path
    end
    # ↑ データの作成を行い「book」として使用することが可能です。
    #   letで指定されたものは遅延評価といってitの中でbookが出てきたときに始めて実行されます。
    #   今回のlet!は事前評価といいます。beforeと似たような使われ方をされますが、beforeではitブロックの実行時に都度実行されます。
    #   そのためit内で使用しない変数の場合にもbeforeは実行されてしまいます。
    context '表示の確認' do
      it 'トップ画面(root_path)に一覧ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: books_path
        # ↑ expect(page)で現在visitメソッドなどで開いているページ全体について調べています。
        #   have_linkではそのページの中のaタグ（link_toヘルパー）で、指定した文字列とhref属性を持ったものが存在するかを判定しています。
        #   今回の場合はhrefにbooksの一覧画面への遷移URLが存在するかをチェックしています。
      end
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
        # ↑ expect(current_path)で現在のページURLを調べています。
        #   eqは、指定した値とexpectの値が同値であるかを判定します。
      end
    end
  end
  describe "一覧画面のテスト" do
    before do
      visit books_path
    end
    context '一覧の表示とリンクの確認' do
      it "bookの一覧表示(tableタグ)と投稿フォームが同一画面に表示されているか" do
        expect(page).to have_selector 'table'
        # ↑ have_selectorでは特定のタグが存在しているか、また特定のタグに特定の文字列があるかなどを判定します。
        #   今回の場合はtableタグが存在しているかを判定しています。
        #   ※特定のタグに特定の文字列があるかなどを判定する場合は以下のように記述します。
        #     expect(page).to have_selector 'p', text: 'テスト'
        #     この場合、ページの中に「テスト」という文字列があるpタグが存在するか判定します。
        expect(page).to have_field 'book[title]'
        # ↑ have_fieldでは指定した値のフォームが存在するか判定します。
        #   今回の場合はbook[title]というname属性のフォームが存在するかで判定しています。
        #   book[title]というname属性は、Bookモデルのtitleカラムを入力するフォームをform_withで作成した際に自動で生成されるものです。
        #   ※編集などで指定のフォームに値が表示されているかを判定する場合は以下のように記述します。
        #     expect(page).to have_field 'book[title]', with: 'テスト'
        expect(page).to have_field 'book[body]'
      end
      it "bookのタイトルと感想を表示し、詳細・編集・削除のリンクが表示されているか" do
          (1..5).each do |i|
            Book.create(title:'hoge'+i.to_s,body:'body'+i.to_s)
          end
          visit books_path
          Book.all.each_with_index do |book,i|
            j = i * 3
            expect(page).to have_content book.title
            expect(page).to have_content book.body
            # Showリンク
            show_link = find_all('a')[j]
            # ↑ find_allでは指定した値（タグ）をページ中から全て検索します。
            #   今回の場合はj番目のaタグをshow_linkに代入しています。
            expect(show_link.native.inner_text).to match(/show/i)
            # ↑ matchは正規表現を用いて文字列をチェックします。
            #  「/show/i」が正規表現で、Rubyでは2本スラッシュで囲んで、最後にオプション（今回は「i」）を付けて表します。
            #   今回の場合は、show_link内のテキストが/show/i（「show」や「Show」,「SHOW」など大文字小文字の違いを無視して判定）
            #   と一致するかどうかを判定します。
            expect(show_link[:href]).to eq book_path(book)
            # Editリンク
            show_link = find_all('a')[j+1]
            expect(show_link.native.inner_text).to match(/edit/i)
            expect(show_link[:href]).to eq edit_book_path(book)
            # Destroyリンク
            show_link = find_all('a')[j+2]
            expect(show_link.native.inner_text).to match(/destroy/i)
            expect(show_link[:href]).to eq book_path(book)
          end
      end
      it 'Create Bookボタンが表示される' do
        expect(page).to have_button 'Create Book'
        # ↑ have_buttonではボタンが存在するかを判定します。
        #   今回の場合はボタン内の文字列の'Create Book'を指定しています。
      end
    end
    context '投稿処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        fill_in 'book[title]', with: Faker::Lorem.characters(number:5)
        # ↑ fill_inではフォームの値を変更します。通常はフォームにテキストを入力すると考えて問題ありません。
        #   今回の場合name属性がbook[title]であるフォームを対象に指定しています。
        #   with:のあとには入力したい文字列を指定します。
        #   今回withの後にはFaker::Lorem.characters(number:5)としていて、5桁のランダムな文字列を入力する形になっています。
        #   ※Fakerはテスト用のダミーデータを作成してくれるもので、GemfileにてFakerを導入しています。
        fill_in 'book[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Create Book'
        # ↑ click_buttonはボタンをクリックします。
        #   ボタン内の文字列を指定します。
        expect(page).to have_content 'successfully'
        # ↑ have_contentでは指定した文字列が含まれているかを判定します。
        #   今回の場合はページ内に「successfully」という文字列があるかを判定します。
      end
      it '投稿に失敗する' do
        click_button 'Create Book'
        expect(page).to have_content 'error'
        expect(current_path).to eq('/books')
      end
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'book[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'book[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Create Book'
        expect(page).to have_current_path book_path(Book.last)
        # ↑ have_current_pathでは現在のURLパスを取得します。
        #   今回の場合は、投稿後のページURLが正しいURLパスであるかを判定しています。
      end
    end
    context 'book削除のテスト' do
      it 'application.html.erbにjavascript_pack_tagを含んでいるか' do
        is_exist = 0
        open("app/views/layouts/application.html.erb").each do |line|
          strip_line = line.chomp.gsub(" ", "")
          if strip_line.include?("<%=javascript_pack_tag'application','data-turbolinks-track':'reload'%>")
            is_exist = 1
            break
          end
        end
        expect(is_exist).to eq(1)
      end
      it 'bookの削除' do
        before_delete_book = Book.count
        click_link 'Destroy', match: :first
        after_delete_book = Book.count
        expect(before_delete_book - after_delete_book).to eq(1)
        expect(current_path).to eq('/books')
      end
    end
  end
  describe '詳細画面のテスト' do
    before do
      visit book_path(book)
    end
    context '表示の確認' do
      it '本のタイトルと感想が画面に表示されていること' do
        expect(page).to have_content book.title
        expect(page).to have_content book.body
      end
      it 'Editリンクが表示される' do
        edit_link = find_all('a')[0]
        expect(edit_link.native.inner_text).to match(/edit/i)
			end
      it 'Backリンクが表示される' do
        back_link = find_all('a')[1]
        expect(back_link.native.inner_text).to match(/back/i)
			end
    end
    context 'リンクの遷移先の確認' do
      it 'Editの遷移先は編集画面か' do
        edit_link = find_all('a')[0]
        edit_link.click
        expect(current_path).to eq('/books/' + book.id.to_s + '/edit')
      end
      it 'Backの遷移先は一覧画面か' do
        back_link = find_all('a')[1]
        back_link.click
        expect(page).to have_current_path books_path
      end
    end
  end
  describe '編集画面のテスト' do
    before do
      visit edit_book_path(book)
    end
    context '表示の確認' do
      it '編集前のタイトルと感想がフォームに表示(セット)されている' do
        expect(page).to have_field 'book[title]', with: book.title
        expect(page).to have_field 'book[body]', with: book.body
      end
      it 'Update Bookボタンが表示される' do
        expect(page).to have_button 'Update Book'
      end
      it 'Showリンクが表示される' do
        show_link = find_all('a')[0]
        expect(show_link.native.inner_text).to match(/show/i)
			end
      it 'Backリンクが表示される' do
        back_link = find_all('a')[1]
        expect(back_link.native.inner_text).to match(/back/i)
			end
    end
    context 'リンクの遷移先の確認' do
      it 'Showの遷移先は詳細画面か' do
        show_link = find_all('a')[0]
        show_link.click
        expect(current_path).to eq('/books/' + book.id.to_s)
      end
      it 'Backの遷移先は一覧画面か' do
        back_link = find_all('a')[1]
        back_link.click
        expect(page).to have_current_path books_path
      end
    end
    context '更新処理に関するテスト' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'book[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'book[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Update Book'
        expect(page).to have_content 'successfully'
      end
      it '更新に失敗しエラーメッセージが表示されるか' do
        fill_in 'book[title]', with: ""
        fill_in 'book[body]', with: ""
        click_button 'Update Book'
        expect(page).to have_content 'error'
      end
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'book[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'book[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Update Book'
        expect(page).to have_current_path book_path(book)
      end
    end
  end
end