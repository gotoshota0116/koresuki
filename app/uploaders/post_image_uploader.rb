class PostImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  if Rails.env.production?
    storage :fog # 本番環境ではS3に保存
  else
    storage :file # 開発・テスト環境ではローカルに保存
  end

  # cloudFront導入
  def initialize(*)
    super
    self.asset_host = 'https://d9oksf3mcywir.cloudfront.net'
  end

  # cloudFront URLを生成
  def url(*args)
    "#{asset_host}/#{store_dir}/#{identifier}"
  end

  def cache_dir
    if Rails.env.test?
      "uploads/#{Rails.env}/tmp/#{mounted_as}/#{model.id}"
    else
      "uploads/tmp/#{mounted_as}/#{model.id}"
    end
  end

  def store_dir
    if Rails.env.test?
      "uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  def size_range
    (1.byte)..(50.megabytes)
  end

  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end

  process resize_to_fill: [420, 320]
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
