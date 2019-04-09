# Tour Model
module KepplerTravel
  class Tour < ActiveRecord::Base
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

    validates :title, :description, :task, :price_adults, presence: true
    validates :banner, presence: true, unless: :skip_banner_validation
    validates :title, uniqueness: true
    validates :destination_ids, presence: true

    def self.bulk_upload(setting_sheetsu)
      api = Sheetsu::Client.new(setting_sheetsu.sheetsu_code_tours)
      tours = api.read
      data = []
      tours.each do |tour|

        ids = tour['destination_ids'].try(:split, ',').try(:map, &:to_i)

        destinations  = Destination.where(id: ids)

        object = Tour.new(
          title: {
            es: tour['title_es'],
            en: tour['title_en'],
            pt: tour['title_pt']
          },

          subtitle: {
            es: tour['subtitle_es'],
            en: tour['subtitle_en'],
            pt: tour['subtitle_pt']
          },

          description: {
            es: tour['description_es'],
            en: tour['description_en'],
            pt: tour['description_pt']
          },

          task: {
            es: tour['task_es'],
            en: tour['task_en'],
            pt: tour['task_pt']
          },

          price_adults: {
            cop: tour['price_adults_cop'],
            usd: tour['price_adults_usd']
          },

          price_kids: {
            cop: tour['price_kids_cop'],
            usd: tour['price_kids_usd']
          },

          destinations: destinations,
          status: tour['status'] == 'TRUE' ? true : false,
          featured: tour['featured'] == 'TRUE' ? true : false,
        )

        object.skip_banner_validation = true
        data << object
      end
      data

    rescue Sheetsu::NotFoundError => e
      data = 'Sheetsu::NotFoundError'
    end

    def low_price(currency)
      [self.price_adults[currency], self.price_kids[currency]].min
    end

    def class_str
      self.class.to_s.split('::').last
    end

    def calculate_kids(currency)
      case self.price_kids[currency].to_f.positive?
        when true
          self.price_kids[currency].to_f
        when false
          self.price_adults[currency]
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

    def selected(destination)
      self.destination_ids.include?(destination) ? 'selected' : false
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["title", "description", "files", "task", "position", "deleted_at"]
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
