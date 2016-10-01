class AddDocToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :doc, :string
  end
end
