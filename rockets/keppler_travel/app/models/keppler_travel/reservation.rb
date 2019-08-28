# Reservation Model
module KepplerTravel
  class Reservation < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    acts_as_paranoid
    mount_uploader :travellers_doc, FileUploader

    # Relationships
    belongs_to :user
    belongs_to :reservationable, -> { with_deleted }, polymorphic: true
    has_one    :invoice#, dependent: :destroy
    has_one    :order#, dependent: :destroy
    has_one    :driver, through: :order
    has_one    :agency, through: :order
    has_one    :agent, through: :order
    has_many   :square, as: :squareable
    has_many   :travellers
    has_one    :document
    accepts_nested_attributes_for :document
    accepts_nested_attributes_for :travellers
    accepts_nested_attributes_for :square
    accepts_nested_attributes_for :order

    # position_status
    # 1 = pending
    # 2 = cancelled
    # 3 = credit_agency
    # 4 = payment_link

    validates_inclusion_of :status, :in => %w(pending cancelled credit_agency payment_link)
    validates_inclusion_of :status_pay, :in => %w(pending cancelled approved)

    def owner
      return user.agent.agency.user.name if user.has_role? :agent
      user.name
    end

    def owner_email
      return user.agent.agency.user.email if user.has_role? :agent
      user.email
    end

    def user
      User.with_deleted.where(id: self.user_id).first
    end

    def self.multiple(object)
      object['round_trip'] == 'true' ? '2' : '1'
    end

    def multiple
      round_trip == 'true' ? '2' : '1'
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

    def pay_to
      "https://receptivocolombia.com/checkout/transaction_payment/#{id}/#{invoice&.id}?locale=es"
      # uri = URI.parse("https://www.enlineapagos.com/secure/gangway/index.do")
      # request = Net::HTTP::Post.new(uri)
      # request.set_form_data(
      #   "usuario" => "RECEPTIVO",
      #   "llavemd5" => "31469c35dfdb7c708d29a1cfe66f6aa9lahs85Xpa12572602401898393042587850772",
      #   "iva" => "0",
      #   "baseiva" => "0",
      #   "valor" => invoice.amount,
      #   "moneda" => invoice.currency.upcase,
      #   "referencia" => invoice.token,
      #   "nombres" => user.name.split(' ').first,
      #   "apellidos" => user.name.split(' ').last,
      #   "email" => user.email,
      #   "documentonumero" => user.dni,
      #   "telefono" => user.phone,
      #   "descripcion" => "Pago de reservacion #{reservationable.title['es']}",
      #   "direccion" => invoice.address,
      #   "urlback" => "https://receptivocolombia.com/es/usd/thanks",
      # )
      #
      # req_options = {
      #   use_ssl: uri.scheme == "https",
      # }
      #
      # response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      #   http.request(request)
      # end
      #
      # response.body.gsub(/\"/,'snowdenattack').split('snowdenattack')[3]
    end


  end
end
