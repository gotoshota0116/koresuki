FactoryBot.define do
	factory :post_image do
	  association :post
	  image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpg') }
		caption {'test_caption'}
	end
end