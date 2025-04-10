FactoryBot.define do
	factory :post_video do
	  association :post
	  youtube_url { 'https://youtu.be/kBpGHXNK8kA?si=EBXrR0ceIgm_0x6u' }
	  caption {'test_caption'}
	end
end