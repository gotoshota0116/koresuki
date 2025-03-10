# 検索条件を受け取り、絞り込みを行うクラス
class PostsFinder
  def initialize(query)
    @q = query # 　検索条件　query [keyword: "入力値"]
    @record = Post.all
  end

  # 検索を実行する
  def search
    search_keyword
    @record
  end

  private

  # 検索キーワード(@q)を受け取り、該当レコードを取得して@recordにいれる
  def search_keyword
    return if @q.keyword.blank?

    keyword = like_search_condition(@q.keyword)
    @record = @record.where('title LIKE ? OR body LIKE ?', keyword, keyword)
  end

  # like検索
  def like_search_condition(word)
    "%#{ActiveRecord::Base.sanitize_sql_like(word)}%"
  end
end
