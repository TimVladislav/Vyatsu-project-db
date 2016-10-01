class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :student_id
      t.string :fio
      t.string :group
      t.string :tnumber
      t.string :email
      t.string :sn
      t.string :typework
      t.string :year
      t.string :teacher
      t.string :workname
      t.string :mark
      t.string :linktowork
      t.timestamps null: false
    end
  end
end
