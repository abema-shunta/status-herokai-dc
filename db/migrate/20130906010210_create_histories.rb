class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :translated_count
      t.integer :ood_count
      t.integer :articles_count

      t.timestamps
    end
  end
end
