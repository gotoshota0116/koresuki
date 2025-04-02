module ApplicationHelper
  include Pagy::Frontend

  def flash_class(key)
    case key.to_sym # key が文字列でも対応できるように to_sym で変換
    when :notice then 'bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-md shadow-md mb-4'
    when :alert then 'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-md shadow-md mb-4'
    else 'bg-blue-500 text-white p-4 rounded-md'
    end
  end

  # application_helper.rb、display_meta_tags(default_meta_tags)に変更必要

  #   {
  #     site: 'シェアスキ！
  #     title: シェアスキ！',
  #     reverse: true,
  #     charset: 'utf-8',
  #     description: '「シェアスキ！は自分の「好き」を投稿するサービスです。
  #     他のユーザーと『好き』を共有し、交流を広げ、新たなつながりを生み出します。」',
  #     canonical: request.original_url,
  #     og: {
  #       site_name: 'シェアスキ！',
  #       title: 'シェアスキ！',
  #       description: '「シェアスキ！は自分の「好き」を投稿するサービスです。
  #       他のユーザーと「好き」を共有し、交流を広げ、新たなつながりを生み出します。」',
  #       type: 'website',
  #       url: request.original_url,
  #       image: image_url('#'),
  #       local: 'ja-JP'
  #     },
  #     twitter: {
  #       card: 'summary_large_image',
  #       site: '@gshota_0116',
  #       image: image_url('#')
  #     }
  #   }
  # end
end
