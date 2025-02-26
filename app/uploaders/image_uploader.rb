class ImageUploader < CarrierWave::Uploader::Base
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

  process resize_to_fit: [1200, 630]
  process :convert_to_webp

  version :mini do
    process resize_to_fill: [400, 350]
    process :convert_to_webp
  end

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
