class ImageUploader < CarrierWave::Uploader::Base
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
  def url(*_args)
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
    %w[jpg jpeg gif png]
  end

  process resize_to_fit: [1200, 630]
  process :optimize

  private

  def optimize
    manipulate! do |img|
      img.strip         # メタデータ削除
      img.quality 80    # 画質を80に設定
      img
    end
  end

  # def heic?(file)
  #   file.extension.downcase == 'heic'
  # end

  # def convert_heic_to_jpg
  #   manipulate! do |img|
  #     img.format('jpg')
  #     img
  #   end
  # end

  # 内部的に呼び出されるメソッド,filenameをオーバーライドしている
  # def filename
  #   return if super.blank? # CarrierWave のデフォルトの filename が存在するか確認

  #   base_name = File.basename(super, '.*')
  #   extension = File.extname(super).downcase == '.heic' ? 'jpg' : File.extname(super).downcase.delete('.')
  #   "#{base_name}.#{extension}"
  # end
end
