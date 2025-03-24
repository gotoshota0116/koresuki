class AvatarUploader < CarrierWave::Uploader::Base
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
    %w[jpg jpeg gif png heic webp]
  end

  process resize_to_fit: [300, 300]
  process :convert_to_webp
  process :optimize

  private

  def convert_to_webp
    manipulate! do |img|
      img.format('webp')
      img
    end
  end

  # 内部的に呼び出されるメソッド,filenameをオーバーライドしている
  def filename
    "#{super.chomp(File.extname(super))}.webp" if original_filename.present?
  end

  def optimize
    manipulate! do |img|
      img.strip # メタデータ削除
      img.quality 80
      img
    end
  end
end
