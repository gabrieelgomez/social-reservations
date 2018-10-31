# Vehicle Model
module KepplerTravel
  class Vehicle < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    mount_uploader :cover, AttachmentUploader
    mount_uploaders :files, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    # Relationships
    has_many :reservations, as: :reservationable
    has_many :vehicleables
    has_and_belongs_to_many :drivers
    has_and_belongs_to_many :destinations
    accepts_nested_attributes_for :vehicleables

    validates :cover, presence: true
    validates :title, uniqueness: true

    def price_total(locality, currency, object)
      if locality[0] == locality[1]
        data    = vehicleables
        result  = data.ransack(title_cont: locality[0]).result.first
        price = result.try("price_#{currency}")
      elsif locality[0] != locality[1]
        price = 1
      end
      object['round_trip'] == 'true' ? price = price.to_f*2 : price = price.to_f
      price
    end

    def class_str
      self.class.to_s.split('::').last
    end

    def set_price(locality, currency)
      if locality[0] == locality[1]
        self.inner_price[currency]
      elsif locality[0] != locality[1]
        self.outer_price[currency]
      end
    end

    def set_price_destination(locality, currency)
      @destiny = vehicleables.ransack(title_cont: locality).result.first
      @destiny.try("price_#{currency}")
    end

    def selected(destination)
      self.destination_ids.include?(destination) ? 'selected' : false
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["title", "date", "time", "inner_price", "position", "deleted_at"]
      build_query(fields, :or, :cont)
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
