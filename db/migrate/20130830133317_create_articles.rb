class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.string :url
      t.timestamp :written_at
      t.timestamp :translated_at
      t.string :category
      t.string :tag

      t.timestamps
    end
  end
end
