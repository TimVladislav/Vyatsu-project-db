class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :fio
      t.string :group
      t.date :date_work
      t.string :subject
      t.string :teacher
      t.string :email
      t.string :sn
      t.string :tnumber

      t.timestamps null: false
    end
  end
end
