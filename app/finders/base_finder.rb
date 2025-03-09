class BaseFinder
	def initialize(q)
	  @q = q
	end
  
	private
  
	# like検索
	def like_search_condition(words)
	  words.map{ |word| ("%#{ActiveRecord::Base.sanitize_sql_like(word)}%") }
	end
  
  end