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

  process :convert_heic_to_jpg, if: :heic?

  def heic?(file)
    file.extension.downcase == 'heic'
  end

  def convert_heic_to_jpg
    manipulate! do |img|
      img.format('jpg')
      img
    end
  end

  # メソッドをオーバーライドして、HEIC形式の画像をJPG形式に変換する
  def filename
    if original_filename.present?
      if file.extension.downcase == 'heic'
        "#{File.basename(original_filename, '.*')}.jpg"
      else
        original_filename
      end
    end
  end

  def extension_allowlist
    %w(jpg jpeg gif png heic)
  end

end
