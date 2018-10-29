# Multidestination Model
module KepplerTravel
  class Multidestination < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    mount_uploader :banner, AttachmentUploader
    mount_uploaders :files, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    # Relationships
    has_and_belongs_to_many :destinations
    # has_and_belongs_to_many :lodgments
    has_many :reservations, as: :reservationable

    has_many :multidestinationables
    # has_many :destinations, through: :multidestinationables
    has_many :lodgments, through: :multidestinationables
    has_many :multidestinationable_rooms, through: :multidestinationables
    # has_many :rooms, through: :multidestinationables

    accepts_nested_attributes_for :multidestinationables
    accepts_nested_attributes_for :multidestinationable_rooms

    def class_str
      self.class.to_s.split('::').last
    end

    def selected(destination)
      self.destination_ids.include?(destination) ? 'selected' : false
    end

    def low_price(currency)
      price = "price_#{currency}".to_sym
      self.multidestinationables.collect{|cc| cc.multidestinationable_rooms.reject{|mr| mr.type_room == 'children'}.map(&price)}.flatten.reject(&:zero?).min
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

    def update_images(images_list)
      unless images_list[:files].nil? || images_list[:files].empty?
        imgs = self.files
        imgs += images_list[:files]
        self.files = imgs
        self.save
      end

      unless images_list[:files_delete].nil? || images_list[:files_delete].empty?
        idx_arr = images_list[:files_delete]
        remain_images = self.files # copy the array
        idx_arr.size.times do |time|
          deleted_image = remain_images.delete_at(idx_arr[time].to_i)
          deleted_image.try(:remove!)
          # images[images_list[time].to_i].remove!
          # images[idx_arr[time].to_i].model[:files].delete_at(idx_arr[time].to_i)
          # self.save
        end
        self.files = remain_images
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
