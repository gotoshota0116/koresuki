class PostsFinder
  def initialize(q)
    @q = q
    @record = Post.all
  end
  
  def execute
    search_keyword
    @record
  end
  
  private
  
  # 検索キーワードを受け取り、該当レコードを取得
  def search_keyword
    return if @q.keyword.blank?
    
    keyword = like_search_condition(@q.keyword)
    @record = @record.where("title LIKE ? OR body LIKE ?", keyword, keyword)
  end
  
  # like検索
  def like_search_condition(word)
    "%#{ActiveRecord::Base.sanitize_sql_like(word)}%"
  end
end