class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :job
      t.string :location
      t.string :skills
      t.string :notes
      t.string :url

      t.timestamps
    end
    add_index :profiles, [:skills, :created_at, :updated_at]
  end
end
