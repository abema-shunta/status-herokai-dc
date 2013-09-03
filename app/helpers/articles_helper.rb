module ArticlesHelper
  
  def tweet_text(article)
    ret = "\
#{article[:name]}を翻訳しました。 \
https://github.com/herokaijp/devcenter/wiki/#{article[:url]} \
https://devcenter.heroku.com/articles/#{article[:url]} \
#herokai_dc" 
    ERB::Util.url_encode(ret.chomp)
  end
  
  def turn_into_single_line(string)
    string.chomp!
    string.gsub!("\t","")
    string.gsub!("\r","")
    string.gsub!("\n","")
    string.gsub!("\"","\\\"")
    string
  end
  
  def status_lead(pages, translated_pages)
    score = translated_pages * 100 / pages
    if I18n.locale.to_s == "ja"
      lead = "全部で記事が#{pages}ページあり、#{translated_pages}ページが翻訳済みです。 #{score}%が翻訳されています。"
    else
      lead = "There are #{pages} pages, and #{translated_pages} pages are translated. #{score}% translated."
    end
    lead
  end
  
end
