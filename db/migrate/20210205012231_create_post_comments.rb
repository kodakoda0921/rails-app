class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.references :micropost, foreign_key: true
      t.references :user, foreign_key: true
      t.string :content

      t.timestamps
    end
    add_index :post_comments, [:micropost_id, :user_id, :created_at]
  end
end
