require 'rails_helper'

RSpec.describe Category do
  it { is_expected.to have_many(:post_categories).dependent(:destroy) }
  it { is_expected.to have_many(:posts).through(:post_categories) }

  describe 'バリデーション成功' do
    context '名前が一意である場合' do
      it 'カテゴリーが作成されること' do
        category = build(:category)
        expect(category).to be_valid
        expect(category.errors).to be_empty
      end
    end
  end

  describe 'バリデーション失敗' do
    context '名前が重複している場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        category = create(:category)
        category2 = build(:category, name: category.name)
        expect(category2).to be_invalid
        expect(category2.errors[:name]).to include('はすでに存在します')
      end
    end
  end
end
