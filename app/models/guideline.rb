class Guideline < ActiveRecord::Base
  mount_uploader :doc, DocUploader
end
