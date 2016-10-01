class Article < ActiveRecord::Base
  has_many :students
  mount_uploader :linktowork, DocUploader
end
