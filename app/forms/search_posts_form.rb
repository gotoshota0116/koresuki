# 検索フォームを作成、検索条件を受け取るクラス
class SearchPostsForm
	include ActiveModel::Model
	include ActiveModel::Attributes
  
	attribute :keyword, :string
  end
  