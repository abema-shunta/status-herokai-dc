module ArticlesHelper
  def tweet_text(article)
    ret = "\
#{article[:name]}を翻訳しました。 \
https://github.com/herokaijp/devcenter/wiki/#{article[:url]} \
https://devcenter.heroku.com/articles/#{article[:url]} \
#herokai_dc" 
    puts ERB::Util.url_encode(ret.chomp)
    ERB::Util.url_encode(ret.chomp)
  end
end
