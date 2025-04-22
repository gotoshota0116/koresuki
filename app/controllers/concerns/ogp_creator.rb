class OgpCreator
  require 'mini_magick'
  BASE_IMAGE_PATH = './app/assets/images/title_ogp_image.jpg'
  GRAVITY = 'center'
  TEXT_POSITION = '0,0'
  FONT = './app/assets/fonts/nikumaru.otf'
  FONT_SIZE = 120
  INDENTION_COUNT = 10
  ROW_LIMIT = 4
  FONT_COLOR = 'rgb(33, 30, 30)'
  LINE_SPACE = 25

  def self.build(text)
    text = prepare_text(text)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      config.font FONT
      config.fill FONT_COLOR
      config.gravity GRAVITY
      config.pointsize FONT_SIZE
      config.interline_spacing LINE_SPACE
      config.draw "text #{TEXT_POSITION} '#{text}'"
    end
  end

  def self.prepare_text(text)
    text = text.to_s
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/o)[0...ROW_LIMIT].join("\n")
  end
end
