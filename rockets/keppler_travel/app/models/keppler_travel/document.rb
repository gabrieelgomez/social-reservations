module KepplerTravel
  class Document < ApplicationRecord
    mount_uploader :file, FileUploader
    belongs_to :reservation, optional: true
  end
end
