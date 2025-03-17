# ユーザー投稿の作成
# 10.times do
#   User.create!(name: Faker::Name.name,
#                email: Faker::Internet.unique.email,
#                password: 'password',
#                password_confirmation: 'password')
# end

# user_ids = User.pluck(:id)

# 20.times do |index|
#   user = User.find(user_ids.sample)
#   user.posts.create!(title: "タイトル#{index}", body: "本文#{index}")
# end

# カテゴリの初期値の作成
categories = [
  '趣味・娯楽',
  '映画・ドラマ・アニメ',
  '本・漫画',
  '音楽',
  'ゲーム',
  'お笑い',
  'スポーツ',
  '動画・配信',
  'アート・デザイン',
  'ファッション・衣服',
  '健康・美容',
  'ライフスタイル・暮らし',
  '食べ物・飲み物',
  'モノ・商品',
  '自然・アウトドア',
  '場所・旅行',
  '動物・ペット',
  '歴史・文化・伝統',
  '人・キャラクター',
  'その他'
]

categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end
