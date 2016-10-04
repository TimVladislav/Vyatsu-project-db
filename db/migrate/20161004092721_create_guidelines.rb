class CreateGuidelines < ActiveRecord::Migration
  def change
    create_table :guidelines do |t|
      t.string :name
      t.string :author
      t.string :subject

      t.timestamps null: false
    end
  end
end
