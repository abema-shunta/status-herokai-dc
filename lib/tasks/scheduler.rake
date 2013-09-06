require "nokogiri"
require "open-uri"
require "date"
require "json"

HEROKU_URL = "https://devcenter.heroku.com"
HEROKU_ARTICLES_URL = "#{HEROKU_URL}/articles"
HEROKAI_WIKI_URL = "https://github.com/herokaijp/devcenter/wiki"

desc "This task is called by the Heroku scheduler add-on"
task :update_status_from_heroku_devcenter => :environment do 

  puts "Updating status..."

  puts "List articles (#{HEROKU_ARTICLES_URL})"
  page = 1
  has_next = true

  articles = []

  while has_next
    puts "page #{page}"
    _articles = Nokogiri::HTML(open("#{HEROKU_ARTICLES_URL}?page=#{page}"))
    list = _articles.css("ul.long-doc-listing li a")
    if list.size > 0
      list.each do |name|
        articles << {:url => name['href'].split("/").last.to_s, :category => "", :tag => "" }
      end
      page += 1
    else
      has_next = false
    end
  end
  
  articles.map! do |article|

    puts "resolving #{article[:url]}'s information"

    ### Add name and updated_at
    _html = Nokogiri::HTML(open("#{HEROKU_ARTICLES_URL}/#{article[:url]}"))
    article[:name] = _html.css("header h1").first.content 
    article[:written_at] = Date.parse(_html.css("p.meta").first.content.split(":").last)
    if active_list = _html.css("li.section li.active a").first
      article[:tag] = active_list.content
    end

    article

  end
  
  articles.each do |article|
  
    a = Article.find_or_create_by url: article[:url]
    a.update_attributes article
  
  end
  
  Rake::Task["update_status_from_github_wiki"].invoke
  
end 

desc "This task is called by the Heroku scheduler add-on"
task :update_status_from_github_wiki => :environment do 

  puts "List articles from Learning (#{HEROKAI_WIKI_URL})"

  articles = Article.all
  articles.each do |article|

    _html = Nokogiri::HTML(open("#{HEROKAI_WIKI_URL}/#{article[:url]}"))
    puts "#{HEROKAI_WIKI_URL}/#{article[:url]}"
    if _html.css("#head h1").first.content == "Home" # appearing editor for creating new article
      article[:translated_at] = nil
    else
      article[:translated_at] = Date.parse(_html.css("#last-edit time").first['title'])
    end
    article.save

  end

  Rake::Task["update_history"].invoke

end

desc "This task is called by the Heroku scheduler add-on"
task :update_history => :environment do

  articles = Article.all
  history = History.new
  
  history.articles_count = articles.size
  history.translated_count = articles.select{|a| a[:translated_at] != nil}.size
  history.ood_count = articles.select{|a| (a[:translated_at] != nil) && (a[:translated_at] < a[:written_at])}.size

  history.save
  
end

