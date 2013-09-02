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
end
