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

  def size_range
    (1.byte)..(10.megabytes)
  end

  def extension_allowlist
    %w[jpg jpeg gif png heic]
  end

  process resize_to_fit: [1200, 630]
  process :convert_heic_to_jpg, if: :heic?
  process :optimize

  version :mini do
    process resize_to_fill: [400, 300]
    process :convert_heic_to_jpg, if: :heic?
    process :optimize
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
    return if super.blank? # CarrierWave のデフォルトの filename が存在するか確認

    base_name = File.basename(super, '.*')
    extension = File.extname(super).downcase == '.heic' ? 'jpg' : File.extname(super).downcase.delete('.')
    "#{base_name}.#{extension}"
  end

  def optimize
    manipulate! do |img|
      img.strip         # メタデータ削除
      img.quality 80    # 画質を80に設定
      img
    end
  end
end
