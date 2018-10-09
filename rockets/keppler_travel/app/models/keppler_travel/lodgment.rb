# Lodgment Model
module KepplerTravel
  class Lodgment < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    acts_as_paranoid

    # Relationships
    # has_many :rooms
    belongs_to :destination
    has_many :square_circuits
    has_many :circuitables
    has_many :circuitable_rooms
    has_many :circuits, through: :circuitables
    has_and_belongs_to_many :rooms

    def selected(destination)
      self.destination_id.eql?(destination) ? 'selected' : false
    end

    def selected_rooms(id)
      self.rooms.map(&:id).include?(id) ? 'selected' : false
    end

    def disabled_room(cr)
      self.rooms.map(&:id).include?(cr.room_id) ? false : true
    end

    def avaible_room? room
      self.rooms.map(&:id).include?(room.room_id) ? true : false
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




# def name_room(id)
#   @name = [
#     ['1', 'single'],
#     ['2', 'doubles'],
#     ['3', 'triples'],
#     ['4', 'quadruples'],
#     ['5', 'quintuples'],
#     ['6', 'sextuples'],
#     ['7', 'children']
#   ]
#   return @name.select{|name| name[0] == id}.flatten
# end
#
# def name_type_rooms
#   @name = []
#   [
#     ['1', 'Simple'],
#     ['2', 'Dobles'],
#     ['3', 'Triples'],
#     ['4', 'Cuadruples'],
#     ['5', 'Quintuples'],
#     ['6', 'Sextuples'],
#     ['7', 'Niños']
#   ].each do |type|
#     @name.push(type[1]) if self.type_rooms.include?(type[0])
#   end
#   return @name
# end
