class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog # 本番環境ではS3に保存
  else
    storage :file # 開発・テスト環境ではローカルに保存
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg gif png heic webp]
  end

  process resize_to_fit: [500, 500]
  process :convert_to_webp

  private

  def convert_to_webp
    manipulate! do |img|
      img.format('webp')
      img
    end
  end

  # 内部的に呼び出されるメソッド,filenameをオーバーライドしている
 def filename
    super.chomp(File.extname(super)) + '.webp' if original_filename.present?
  end
end
