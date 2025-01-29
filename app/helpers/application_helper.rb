module ApplicationHelper
  def flash_class(key)
    case key.to_sym # key が文字列でも対応できるように to_sym で変換
    when :notice then 'bg-green-500 text-white p-4 rounded-md'
    when :alert  then 'bg-red-500 text-white p-4 rounded-md'
    else 'bg-blue-500 text-white p-4 rounded-md'
    end
  end
end
