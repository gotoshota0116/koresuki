require 'rails_helper'

RSpec.describe Notification do
  it { is_expected.to belong_to(:visitor).class_name('User') }
  it { is_expected.to belong_to(:visited).class_name('User') }
  it { is_expected.to belong_to(:notifiable) }

  describe 'バリデーション成功' do
    context 'すべての属性が正しく設定されている場合' do
      it 'いいね通知が作成されること' do
        notification = build(:notification)
        expect(notification).to be_valid
        expect(notification.errors).to be_empty
      end
    end

	context 'すべての属性が正しく設定されている場合' do
		it 'コメント通知が作成されること' do
		  notification = build(:notification, action: 'commented')
		  expect(notification).to be_valid
		  expect(notification.errors).to be_empty
		end
	  end
  end

  describe 'バリデーション失敗' do
    context 'actionが空白の場合' do
      it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
        notification = build(:notification, action: nil)
        expect(notification).to be_invalid
        expect(notification.errors[:action]).to include('を入力してください')
      end
    end

    context 'checkedが空白の場合' do
		it 'バリデーションエラーが発生し、エラーメッセージが表示されること' do
		  notification = build(:notification, checked: nil)
		  expect(notification).to be_invalid
		  expect(notification.errors[:checked]).to include('は一覧にありません')
		end
	  end
  end
end
