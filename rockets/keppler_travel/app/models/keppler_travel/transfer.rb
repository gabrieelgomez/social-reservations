# Transfer Model
module KepplerTravel
  class Transfer < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    mount_uploader :cover, AttachmentUploader
    acts_as_list
    # Fields for the search form in the navbar

    # serialize :title, HashSerializer
    # attr_accessor :title, :es, :en, :pt
    # validates :es, :en, :pt, presence: true
    has_and_belongs_to_many :destinations
    validates :destination_ids, presence: true

    def self.search_field
      fields = ["cover", "title", "quantity_person", "date", "time", "price", "position", "deleted_at"]
      build_query(fields, :or, :cont)
    end

    def self.upload(file)
      CSV.foreach(file.path, headers: true) do |row|
        begin
          self.create! row.to_hash
        rescue => err
        end
      end
    end

    def self.sorter(params)
      params.each_with_index do |id, idx|
        self.find(id).update(position: idx.to_i+1)
      end
    end

    # Funcion para armar el query de ransack
    def self.build_query(fields, operator, conf)
      query = fields.join("_#{operator}_")
      query << "_#{conf}"
      query.to_sym
    end
  end
end
