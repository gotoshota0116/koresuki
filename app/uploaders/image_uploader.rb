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
    %w(jpg jpeg gif png heic)
  end

  process resize_to_fit: [600,600]
  process :convert_heic_to_jpg, if: :heic?

  version :mini do
    process resize_to_fill: [400, 350]
    process :convert_heic_to_jpg, if: :heic?
  end

private

  def heic?(file)
    file.extension.downcase == 'heic'
  end

  def convert_heic_to_jpg
    manipulate! do |img|
      img.format('jpg')
      img
    end
  end

  # 内部的に呼び出されるメソッド,filenameをオーバーライドしている
  def filename
    if super.present?  # CarrierWave のデフォルトの filename が存在するか確認
      base_name = File.basename(super, '.*')
      extension = File.extname(super).downcase == '.heic' ? 'jpg' : File.extname(super).downcase.delete('.')
      "#{base_name}.#{extension}"
    end
  end

end
