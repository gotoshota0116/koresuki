# 検索条件を受け取り、絞り込みを行うクラス
class PostsFinder
  def initialize(query)
    @q = query # 　検索条件　query [keyword: "入力値"]
    @record = Post.all
  end

  # 検索を実行する
  def search
    search_keyword
    search_category
    @record
  end

  private

  # 検索キーワード(@q)を受け取り、該当レコードを取得して@recordにいれる
  def search_keyword
    return if @q.keyword.blank?

    keyword = like_search_condition(@q.keyword)
    @record = @record.joins(:user).where('posts.title LIKE ? OR posts.body LIKE ? OR users.name LIKE ?', keyword, keyword, keyword)
  end

  # like検索
  def like_search_condition(word)
    "%#{ActiveRecord::Base.sanitize_sql_like(word)}%"
  end

  def search_category
    return if @q.category.blank?

    category = Category.find(@q.category)
    @record = @record.joins(:categories).where(categories: { id: category.id })
  end
end
