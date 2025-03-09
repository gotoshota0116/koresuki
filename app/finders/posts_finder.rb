class PostsFinder < BaseFinder
  def initialize(q)
    @record = Post.all
    super(q)
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
  
end