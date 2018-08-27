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
    store_accessor :title, [:es, :en, :pt]

    def self.jsonb()

    end

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
