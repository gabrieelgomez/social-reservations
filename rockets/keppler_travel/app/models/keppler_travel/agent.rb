# Agent Model
module KepplerTravel
  class Agent < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    acts_as_paranoid

    belongs_to :user
    belongs_to :agency
    has_many :orders
    has_many :reservations, through: :orders
    accepts_nested_attributes_for :user

    validates :unique_code, :comission_percentage, :lending_percentage, :user_id, :agency_id, presence: true
    # validates :unique_code, uniqueness: true

    def user
      User.with_deleted.find(self.user_id)
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["unique_code", "comission_percentage", "lending_percentage", "user_id", "agency_id", "position", "deleted_at"]
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
