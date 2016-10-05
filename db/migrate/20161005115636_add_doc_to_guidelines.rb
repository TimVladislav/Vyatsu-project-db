class AddDocToGuidelines < ActiveRecord::Migration
  def change
    add_column :guidelines, :doc, :string
  end
end
