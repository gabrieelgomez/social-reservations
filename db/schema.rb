# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_02_22_175538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "appearances", force: :cascade do |t|
    t.string "image_background"
    t.string "theme_name"
    t.string "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customizes", force: :cascade do |t|
    t.string "file"
    t.boolean "installed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "google_analytics_settings", force: :cascade do |t|
    t.string "ga_account_id"
    t.string "ga_tracking_id"
    t.boolean "ga_status"
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keppler_contactus_messages", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "content"
    t.boolean "read"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_keppler_contactus_messages_on_deleted_at"
  end

  create_table "keppler_contactus_requests", force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "dni"
    t.string "country"
    t.string "phone"
    t.string "email"
    t.text "body"
    t.string "options"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keppler_travel_agencies", force: :cascade do |t|
    t.string "unique_code", default: "03D27F"
    t.float "comission_percentage", default: 0.0
    t.float "lending_percentage", default: 0.0
    t.bigint "user_id"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address", default: ""
    t.string "nit", default: ""
    t.string "rnt", default: ""
    t.string "country", default: ""
    t.string "owner", default: ""
    t.index ["deleted_at"], name: "index_keppler_travel_agencies_on_deleted_at"
    t.index ["user_id"], name: "index_keppler_travel_agencies_on_user_id"
  end

  create_table "keppler_travel_agents", force: :cascade do |t|
    t.string "unique_code", default: "362700"
    t.float "comission_percentage", default: 0.0
    t.float "lending_percentage", default: 0.0
    t.bigint "user_id"
    t.bigint "agency_id"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agency_id"], name: "index_keppler_travel_agents_on_agency_id"
    t.index ["deleted_at"], name: "index_keppler_travel_agents_on_deleted_at"
    t.index ["user_id"], name: "index_keppler_travel_agents_on_user_id"
  end

  create_table "keppler_travel_car_descriptions", force: :cascade do |t|
    t.string "license"
    t.string "color"
    t.bigint "driver_id"
    t.bigint "vehicle_id"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["driver_id"], name: "index_keppler_travel_car_descriptions_on_driver_id"
    t.index ["vehicle_id"], name: "index_keppler_travel_car_descriptions_on_vehicle_id"
  end

  create_table "keppler_travel_circuitable_rooms", force: :cascade do |t|
    t.float "price_cop"
    t.float "price_usd"
    t.boolean "status"
    t.bigint "room_id"
    t.bigint "circuitable_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "night_price_usd", default: 0.0
    t.float "night_price_cop", default: 0.0
    t.index ["circuitable_id"], name: "index_keppler_travel_circuitable_rooms_on_circuitable_id"
    t.index ["room_id"], name: "index_keppler_travel_circuitable_rooms_on_room_id"
  end

  create_table "keppler_travel_circuitables", force: :cascade do |t|
    t.bigint "ranking_id"
    t.bigint "circuit_id"
    t.boolean "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["circuit_id"], name: "index_keppler_travel_circuitables_on_circuit_id"
    t.index ["ranking_id"], name: "index_keppler_travel_circuitables_on_ranking_id"
  end

  create_table "keppler_travel_circuits", force: :cascade do |t|
    t.jsonb "title"
    t.integer "quantity_days"
    t.jsonb "description"
    t.jsonb "include"
    t.jsonb "exclude"
    t.jsonb "itinerary"
    t.string "banner"
    t.boolean "status", default: true
    t.jsonb "files"
    t.boolean "featured"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "subtitle"
    t.index ["deleted_at"], name: "index_keppler_travel_circuits_on_deleted_at"
  end

  create_table "keppler_travel_circuits_destinations", force: :cascade do |t|
    t.bigint "circuit_id"
    t.bigint "destination_id"
    t.index ["circuit_id"], name: "index_keppler_travel_circuits_destinations_on_circuit_id"
    t.index ["destination_id"], name: "index_keppler_travel_circuits_destinations_on_destination_id"
  end

  create_table "keppler_travel_destinations", force: :cascade do |t|
    t.string "title"
    t.float "latitude"
    t.float "longitude"
    t.jsonb "custom_title"
    t.string "cover"
    t.jsonb "description"
    t.integer "position"
    t.boolean "status", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_keppler_travel_destinations_on_deleted_at"
  end

  create_table "keppler_travel_destinations_multidestinations", force: :cascade do |t|
    t.bigint "destination_id"
    t.bigint "multidestination_id"
    t.index ["destination_id"], name: "destination_multidestination_id"
    t.index ["multidestination_id"], name: "multidestination_id"
  end

  create_table "keppler_travel_destinations_tours", force: :cascade do |t|
    t.bigint "destination_id"
    t.bigint "tour_id"
    t.datetime "deleted_at"
    t.index ["destination_id"], name: "index_keppler_travel_destinations_tours_on_destination_id"
    t.index ["tour_id"], name: "index_keppler_travel_destinations_tours_on_tour_id"
  end

  create_table "keppler_travel_destinations_vehicles", force: :cascade do |t|
    t.bigint "destination_id"
    t.bigint "vehicle_id"
    t.datetime "deleted_at"
    t.index ["destination_id"], name: "destination_id"
    t.index ["vehicle_id"], name: "vehicle_id"
  end

  create_table "keppler_travel_drivers", force: :cascade do |t|
    t.string "timetrack"
    t.integer "position"
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank"
    t.string "account_type"
    t.text "account_number"
    t.integer "destination_id"
    t.string "email_corporative", default: "example@example.com"
    t.index ["deleted_at"], name: "index_keppler_travel_drivers_on_deleted_at"
    t.index ["user_id"], name: "index_keppler_travel_drivers_on_user_id"
  end

  create_table "keppler_travel_drivers_vehicles", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "vehicle_id"
    t.datetime "deleted_at"
    t.index ["driver_id"], name: "driver_id"
    t.index ["vehicle_id"], name: "index_keppler_travel_drivers_vehicles_on_vehicle_id"
  end

  create_table "keppler_travel_invoices", force: :cascade do |t|
    t.string "token"
    t.string "amount"
    t.string "currency"
    t.string "status"
    t.text "address"
    t.bigint "reservation_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status_pay", default: "pending"
    t.index ["deleted_at"], name: "index_keppler_travel_invoices_on_deleted_at"
    t.index ["reservation_id"], name: "index_keppler_travel_invoices_on_reservation_id"
  end

  create_table "keppler_travel_licenses", force: :cascade do |t|
    t.string "matricula"
    t.string "color"
    t.bigint "car_description_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["car_description_id"], name: "index_keppler_travel_licenses_on_car_description_id"
  end

  create_table "keppler_travel_lodgments", force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "address"
    t.string "email"
    t.integer "phone_one"
    t.integer "phone_two"
    t.jsonb "files"
    t.boolean "status", default: true
    t.string "type_rooms", array: true
    t.bigint "destination_id"
    t.bigint "ranking_id"
    t.datetime "deleted_at"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_keppler_travel_lodgments_on_deleted_at"
    t.index ["destination_id"], name: "index_keppler_travel_lodgments_on_destination_id"
    t.index ["ranking_id"], name: "index_keppler_travel_lodgments_on_ranking_id"
  end

  create_table "keppler_travel_lodgments_rooms", force: :cascade do |t|
    t.bigint "lodgment_id"
    t.bigint "room_id"
    t.datetime "deleted_at"
    t.index ["lodgment_id"], name: "index_keppler_travel_lodgments_rooms_on_lodgment_id"
    t.index ["room_id"], name: "index_keppler_travel_lodgments_rooms_on_room_id"
  end

  create_table "keppler_travel_multidestinationable_rooms", force: :cascade do |t|
    t.float "price_cop"
    t.float "price_usd"
    t.boolean "status"
    t.bigint "room_id"
    t.bigint "multidestinationable_id"
    t.datetime "deleted_at"
    t.float "night_price_usd", default: 0.0
    t.float "night_price_cop", default: 0.0
    t.index ["multidestinationable_id"], name: "multidestinationable_id"
    t.index ["room_id"], name: "index_keppler_travel_multidestinationable_rooms_on_room_id"
  end

  create_table "keppler_travel_multidestinationables", force: :cascade do |t|
    t.bigint "destination_id"
    t.bigint "lodgment_id"
    t.bigint "multidestination_id"
    t.boolean "status"
    t.datetime "deleted_at"
    t.index ["destination_id"], name: "index_keppler_travel_multidestinationables_on_destination_id"
    t.index ["lodgment_id"], name: "index_keppler_travel_multidestinationables_on_lodgment_id"
    t.index ["multidestination_id"], name: "multidestinationable_multidestination_id"
  end

  create_table "keppler_travel_multidestinations", force: :cascade do |t|
    t.jsonb "title"
    t.integer "quantity_days"
    t.jsonb "description"
    t.jsonb "include"
    t.jsonb "exclude"
    t.jsonb "itinerary"
    t.string "banner"
    t.boolean "status", default: true
    t.jsonb "files"
    t.boolean "featured"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "subtitle"
    t.index ["deleted_at"], name: "index_keppler_travel_multidestinations_on_deleted_at"
  end

  create_table "keppler_travel_orders", force: :cascade do |t|
    t.string "status"
    t.string "details"
    t.bigint "driver_id"
    t.bigint "reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agency_id"
    t.float "comission", default: 0.0
    t.float "lending", default: 0.0
    t.float "price_comission", default: 0.0
    t.float "price_lending", default: 0.0
    t.float "price_total_agency", default: 0.0
    t.float "price_total_pax", default: 0.0
    t.float "price_vehicle", default: 0.0
    t.integer "agent_id"
    t.datetime "deleted_at"
    t.string "user_referer"
    t.integer "driver_referer"
    t.integer "agency_referer"
    t.integer "agent_referer"
    t.string "status_pay", default: "pending"
    t.string "url_payment", default: ""
    t.index ["driver_id"], name: "index_keppler_travel_orders_on_driver_id"
    t.index ["reservation_id"], name: "index_keppler_travel_orders_on_reservation_id"
  end

  create_table "keppler_travel_rankings", force: :cascade do |t|
    t.jsonb "title"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_keppler_travel_rankings_on_deleted_at"
  end

  create_table "keppler_travel_reservations", force: :cascade do |t|
    t.string "origin"
    t.string "arrival"
    t.string "origin_location"
    t.string "arrival_location"
    t.string "flight_origin"
    t.string "flight_arrival"
    t.integer "quantity_adults"
    t.integer "quantity_kids"
    t.integer "quantity_kit"
    t.string "round_trip"
    t.string "airline_origin"
    t.string "airline_arrival"
    t.string "flight_number_origin"
    t.string "flight_number_arrival"
    t.text "description"
    t.string "status"
    t.bigint "user_id"
    t.integer "reservationable_id"
    t.string "reservationable_type"
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hour_origin"
    t.string "hour_arrival"
    t.integer "position_status", default: 1
    t.string "status_pay", default: "pending"
    t.integer "position_status_pay", default: 1
    t.string "url_payment", default: ""
    t.index ["deleted_at"], name: "index_keppler_travel_reservations_on_deleted_at"
    t.index ["reservationable_id"], name: "reservationable_id"
    t.index ["reservationable_type"], name: "reservationable_type"
    t.index ["user_id"], name: "index_keppler_travel_reservations_on_user_id"
  end

  create_table "keppler_travel_rooms", force: :cascade do |t|
    t.string "type_room"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keppler_travel_squares", force: :cascade do |t|
    t.integer "single", default: 0
    t.integer "doubles", default: 0
    t.integer "triples", default: 0
    t.integer "quadruples", default: 0
    t.integer "quintuples", default: 0
    t.integer "sextuples", default: 0
    t.integer "children", default: 0
    t.integer "optional", default: 0
    t.bigint "lodgment_id"
    t.bigint "ranking_id"
    t.bigint "reservation_id"
    t.integer "squareable_id"
    t.string "squareable_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lodgment_id"], name: "index_keppler_travel_squares_on_lodgment_id"
    t.index ["ranking_id"], name: "index_keppler_travel_squares_on_ranking_id"
    t.index ["reservation_id"], name: "index_keppler_travel_squares_on_reservation_id"
  end

  create_table "keppler_travel_tours", force: :cascade do |t|
    t.jsonb "title"
    t.jsonb "description"
    t.jsonb "task"
    t.jsonb "files"
    t.jsonb "price_adults"
    t.jsonb "price_kids"
    t.string "banner"
    t.boolean "status", default: true
    t.integer "position"
    t.boolean "featured"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "subtitle"
    t.index ["deleted_at"], name: "index_keppler_travel_tours_on_deleted_at"
  end

  create_table "keppler_travel_travellers", force: :cascade do |t|
    t.string "name"
    t.string "dni"
    t.datetime "deleted_at"
    t.bigint "reservation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_keppler_travel_travellers_on_deleted_at"
    t.index ["reservation_id"], name: "reservation_id"
  end

  create_table "keppler_travel_vehicleables", force: :cascade do |t|
    t.string "title"
    t.boolean "status", default: false
    t.float "price_inner_usd", default: 0.0
    t.float "price_inner_cop", default: 0.0
    t.bigint "vehicle_id"
    t.bigint "destination_id"
    t.datetime "deleted_at"
    t.float "price_outer_cop", default: 0.0
    t.float "price_outer_usd", default: 0.0
    t.index ["destination_id"], name: "index_keppler_travel_vehicleables_on_destination_id"
    t.index ["vehicle_id"], name: "index_keppler_travel_vehicleables_on_vehicle_id"
  end

  create_table "keppler_travel_vehicles", force: :cascade do |t|
    t.string "cover"
    t.jsonb "title"
    t.jsonb "description"
    t.jsonb "includes"
    t.jsonb "conditions"
    t.jsonb "files"
    t.jsonb "kit"
    t.integer "seat"
    t.datetime "date"
    t.datetime "time"
    t.jsonb "inner_price"
    t.jsonb "outer_price"
    t.integer "position"
    t.boolean "status", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_keppler_travel_vehicles_on_deleted_at"
  end

  create_table "meta_tags", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "meta_tags"
    t.string "url"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.jsonb "modules"
    t.bigint "role_id"
    t.string "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "scaffolds", force: :cascade do |t|
    t.string "name"
    t.string "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scripts", force: :cascade do |t|
    t.string "name"
    t.text "script"
    t.string "url"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "phone"
    t.string "mobile"
    t.string "email"
    t.string "logo"
    t.string "favicon"
    t.text "terms_conditions_es"
    t.text "privacy_policies_es"
    t.text "cancellations_es"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "terms_conditions_en"
    t.text "terms_conditions_pt"
    t.text "privacy_policies_en"
    t.text "privacy_policies_pt"
    t.text "cancellations_en"
    t.text "cancellations_pt"
  end

  create_table "smtp_settings", force: :cascade do |t|
    t.string "address"
    t.string "port"
    t.string "domain_name"
    t.string "email"
    t.string "password"
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_accounts", force: :cascade do |t|
    t.string "facebook"
    t.string "twitter"
    t.string "instagram"
    t.string "google_plus"
    t.string "tripadvisor"
    t.string "pinterest"
    t.string "flickr"
    t.string "behance"
    t.string "dribbble"
    t.string "tumblr"
    t.string "github"
    t.string "linkedin"
    t.string "soundcloud"
    t.string "youtube"
    t.string "skype"
    t.string "vimeo"
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.string "name"
    t.string "permalink"
    t.string "username"
    t.string "phone"
    t.string "dni"
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "accessable_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "keppler_travel_reservations", "users"
  add_foreign_key "permissions", "roles"
end
