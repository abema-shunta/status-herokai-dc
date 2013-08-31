json.array!(@articles) do |article|
  json.extract! article, :name, :url, :written_at, :translated_at, :category, :tag
  json.url article_url(article, format: :json)
end
