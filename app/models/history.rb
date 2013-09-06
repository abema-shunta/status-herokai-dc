class History < ActiveRecord::Base

  def untransrated_count
    articles_count - translated_count
  end

  def fresh_count
    translated_count - ood_count
  end
  
end
