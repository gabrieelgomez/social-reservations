# Destination Model
module KepplerTravel
  class Destination < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    mount_uploader :cover, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    has_many :lodgments
    has_many :drivers
    has_many :vehicleables
    has_many :multidestinationables
    has_and_belongs_to_many :circuits
    has_and_belongs_to_many :multidestinations
    has_and_belongs_to_many :tours
    has_and_belongs_to_many :vehicles
    validates :title, :latitude, :longitude, :custom_title, uniqueness: true, presence: true
    # validates :cover, presence: true

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["title", "cover", "description", "position", "deleted_at"]
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
