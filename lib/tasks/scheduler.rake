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

  puts "List articles from Learning (https://devcenter.heroku.com/categories/learning)"
  page = 1
  has_next = true

  while has_next
    puts "page #{page}"
    _articles = Nokogiri::HTML(open("#{HEROKU_ARTICLES_URL}/learning?page=#{page}"))
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
    article[:updated_at] = Date.parse(_html.css("p.meta").first.content.split(":").last)
    if active_list = _html.css("li.section li.active a").first
      article[:tag] = active_list.content
    end

    article

  end
  
end 

task :update_status_from_github_wiki => :environment do 

  articles.map! do |article|
    _html = Nokogiri::HTML(open("#{HEROKAI_WIKI_URL}/#{article["url"]}"))
    puts "#{HEROKAI_WIKI_URL}/#{article["url"]}"
    puts _html.css("#head h1").first.content
    if _html.css("#head h1").first.content == "Home" # appearing editor for creating new article
      article["translated_at"] = nil
    else
      article["translated_at"] = Date.parse(_html.css("#last-edit time").first['title'])
    end
    puts article
    article
  end

end