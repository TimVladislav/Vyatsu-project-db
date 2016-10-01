class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :fio
      t.datetime :birthday
      t.string :tnumber
      t.string :email
      t.string :post

      t.timestamps null: false
    end
  end
end
