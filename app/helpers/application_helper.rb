module ApplicationHelper
  def flash_class(key)
    case key.to_sym # key が文字列でも対応できるように to_sym で変換
    when :notice then "bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-md shadow-md mb-4"
    when :alert  then "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-md shadow-md mb-4"
    when :success then "bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-md shadow-md mb-4"
    when :danger then "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-md shadow-md mb-4"
    else 'bg-blue-500 text-white p-4 rounded-md'
    end
  end
end
