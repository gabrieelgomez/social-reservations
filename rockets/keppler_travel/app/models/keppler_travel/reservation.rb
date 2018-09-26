# Reservation Model
module KepplerTravel
  class Reservation < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    acts_as_paranoid

    # Relationships
    belongs_to :user
    # belongs_to :vehicle
    belongs_to :reservationable, -> { with_deleted }, polymorphic: true
    has_one    :invoice
    has_many   :travellers
    accepts_nested_attributes_for :travellers

    def self.multiple(object)
      object['round_trip'] == 'true' ? '2' : '1'
    end

    def self.price_total(locality, object, objectable, currency)
      if locality[0] == locality[1]
        price = objectable.inner_price[currency]
      elsif locality[0] != locality[1]
        price = objectable.outer_price[currency]
      end
      object['round_trip'] == 'true' ? price = price.to_f*2 : price = price.to_f
      return price
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["origin", "arrival"]
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
