# Circuit Model
module KepplerTravel
  class Circuit < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    mount_uploader :banner, AttachmentUploader
    mount_uploaders :files, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    attr_accessor :skip_banner_validation

    # Relationships
    has_and_belongs_to_many :destinations
    has_many :reservations, as: :reservationable

    # Relationships Poly
    has_many :circuitables
    has_many :rankings, through: :circuitables
    has_many :circuitable_rooms, through: :circuitables

    accepts_nested_attributes_for :circuitables
    accepts_nested_attributes_for :circuitable_rooms

    validates :banner, presence: true, unless: :skip_banner_validation

    def self.bulk_upload(setting_sheetsu)
      api = Sheetsu::Client.new(setting_sheetsu.sheetsu_code_circuits)
      circuits = api.read
      data = []
      circuits.each do |circuit|

        object = Circuit.new(
          title: {
            es: circuit['title_es'],
            en: circuit['title_en'],
            pt: circuit['title_pt']
          },

          subtitle: {
            es: circuit['subtitle_es'],
            en: circuit['subtitle_en'],
            pt: circuit['subtitle_pt']
          },

          description: {
            es: circuit['description_es'],
            en: circuit['description_en'],
            pt: circuit['description_pt']
          },

          include: {
            es: circuit['include_es'],
            en: circuit['include_en'],
            pt: circuit['include_pt']
          },

          exclude: {
            es: circuit['exclude_es'],
            en: circuit['exclude_en'],
            pt: circuit['exclude_pt']
          },

          itinerary: {
            es: circuit['itinerary_es'],
            en: circuit['itinerary_en'],
            pt: circuit['itinerary_pt']
          },

          quantity_days: circuit['quantity_days'],
          status: circuit['status'] == 'TRUE' ? true : false,
          featured: circuit['featured'] == 'TRUE' ? true : false,
        )

        object.skip_banner_validation = true
        data << object
      end
      data

    rescue Sheetsu::NotFoundError => e
      data = 'Sheetsu::NotFoundError'
    end

    def class_str
      self.class.to_s.split('::').last
    end

    def selected(destination)
      self.destination_ids.include?(destination) ? 'selected' : false
    end

    def low_price(currency)
      price = "price_#{currency}".to_sym
      self.circuitables.collect{|cc|  cc.circuitable_rooms.reject{|mr| mr.type_room == 'children'}.map(&price)}.flatten.reject(&:zero?).min
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["title", "quantity_days", "description", "include", "exclude", "itinerary", "status", "files", "position", "deleted_at"]
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
