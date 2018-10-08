# Circuit Model
module KepplerTravel
  class Circuit < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    mount_uploaders :files, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    # Relationships
    # has_and_belongs_to_many :destinations
    # has_and_belongs_to_many :lodgments
    has_many :reservations, as: :reservationable

    has_many :circuitables
    has_many :destinations, through: :circuitables
    has_many :lodgments, through: :circuitables
    has_many :circuitable_rooms, through: :circuitables
    # has_many :rooms, through: :circuitables

    accepts_nested_attributes_for :circuitables
    accepts_nested_attributes_for :circuitable_rooms

    def selected(destination)
      self.destination_ids.include?(destination) ? 'selected' : false
    end

    def low_price(currency)
      price = "price_#{currency}".to_sym
      self.circuitables.collect{|cc|  cc.circuitable_rooms.map(&price)}.flatten.reject(&:zero?).min
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["title", "quantity_days", "description", "include", "exclude", "files", "position", "deleted_at"]
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
