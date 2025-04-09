require 'rails_helper'

RSpec.describe Post do
	it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }
  it { is_expected.to have_many(:liked_users).through(:likes).source(:user) }
  it { is_expected.to have_many(:notifications).dependent(:destroy) }
  it { is_expected.to have_many(:post_images).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:post_images).allow_destroy(true) }
  it { is_expected.to have_many(:post_videos).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:post_videos).allow_destroy(true) }
  it { is_expected.to have_many(:post_categories).dependent(:destroy) }
  it { is_expected.to have_many(:categories).through(:post_categories) }
  it { is_expected.to have_many(:bookmarks).dependent(:destroy) }

end