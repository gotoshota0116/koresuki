class CustomDeviseMailer < Devise::Mailer
  default from: 'koresuki.info@gmail.com' # 送信元を変更

  def confirmation_instructions(record, token, opts = {})
    opts[:subject] = '【シェアスキ！】メールアドレスの確認' # 件名をカスタマイズ
    super
  end
end
