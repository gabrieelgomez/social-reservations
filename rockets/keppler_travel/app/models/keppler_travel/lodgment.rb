# Lodgment Model
module KepplerTravel
  class Lodgment < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    acts_as_paranoid

    # Relationships
    has_many :rooms
    belongs_to :destination

    def selected(destination)
      self.destination_id.eql?(destination) ? 'selected' : false
    end

    def str(room)
      self.type_rooms.try(:include?, room) ? 'selected' : false
    end

    def disabled_room(room)
      self.type_rooms.try(:exclude?, room) ? true : false
    end

    def name_type_rooms
      @name = []
      [
        ['1', 'Simple'],
        ['2', 'Niños'],
        ['3', 'Dobles'],
        ['4', 'Triples'],
        ['5', 'Cuadruples'],
        ['6', 'Quintuples'],
        ['7', 'Sextuples']
      ].each do |type|
        @name.push(type[1]) if self.type_rooms.include?(type[0])
      end
      return @name
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["title", "position", "deleted_at"]
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
