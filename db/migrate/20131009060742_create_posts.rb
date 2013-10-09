class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :file_url
      t.text :context
      t.integer :user_id

      t.timestamps
    end
  end
end
