# Driver Model
module KepplerTravel
  class Driver < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list

    belongs_to :user, dependent: :destroy
    has_many :orders
    has_many :reservations, through: :orders
    accepts_nested_attributes_for :user
    # Fields for the search form in the navbar
    def self.search_field
      fields = ["timetrack", "position", "deleted_at"]
      build_query(fields, :or, :cont)
    end

    def self.driver_avaible
      all.reject{|driver| driver.orders.map(&:status).count('pending').positive? }
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
