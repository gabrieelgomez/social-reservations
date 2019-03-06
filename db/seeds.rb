# This file should contain all the record creation needed to seed
# the database with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

%i[keppler_admin admin client partner driver].each do |name|
  Role.create name: name
  puts "Role #{name} has been created"
end

User.create(
  name: 'Keppler Admin', email: 'admin@keppleradmin.com', password: '+12345678+',
  password_confirmation: '+12345678+', role_ids: '1'
)

puts 'admin@keppleradmin.com has been created'

Customize.create(file: '', installed: true)
puts 'Keppler Template has been created'
# Create setting deafult
setting = Setting.create(
  name: 'Keppler Admin', description: 'Welcome to Keppler Admin',

  terms_conditions_es: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt
  ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
  nisi ut aliquip ex ea commodo consequat.
  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',

  privacy_policies_es: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt
  ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
  nisi ut aliquip ex ea commodo consequat.
  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',

  cancellations_es: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt
  ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
  nisi ut aliquip ex ea commodo consequat.
  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',

  smtp_setting_attributes: {
    address: 'test', port: '25', domain_name: 'keppler.com',
    email: 'info@keppler.com', password: '12345678'
  },
  google_analytics_setting_attributes: {
    ga_account_id: '60688852',
    ga_tracking_id: 'UA-60688852-1',
    ga_status: true
  }
)
setting.social_account = SocialAccount.new
setting.appearance = Appearance.new(theme_name: 'keppler')
setting.save
puts 'Setting default has been created'

if defined?(KepplerContactUs) && KepplerContactUs.is_a?(Class)
  KepplerContactUs::MessageSetting.create(
    mailer_from: 'contacto@slicegroup.xyz',
    mailer_to: 'contacto@slicegroup.xyz'
  )
  puts 'KepplerContactUs mailer_to and mailer_from has been created'
end


# Create Destinations
destinations = [
  {
    title: 'Cartagena, Bolívar, Colombia',
    latitude: 10.3910485,
    longitude: -75.479425699,
    custom_title: {
      es: 'Cartagena',
      en: 'Cartagena',
      pt: 'Cartagena'
    }
  },
  {
    title: 'Medellín, Antioquia, Colombia',
    latitude: 6.2530408,
    longitude: -75.564573699999,
    custom_title: {
      es: 'Medellín',
      en: 'Medellín',
      pt: 'Medellín'
    }
  },
  {
    title: 'Barranquilla, Atlántico, Colombia',
    latitude: 10.3910485,
    longitude: -75.479425699,
    custom_title: {
      es: 'Barranquilla',
      en: 'Barranquilla',
      pt: 'Barranquilla'
    }
  }
]

rankings  = ['3 Estrella Superior', '4 Estrellas', '5 Estrellas']
lodgments = ['Hotel Mirasol', 'Hotel Bijou', 'Hotel Eurobuilding', 'Hotel Paraguaná']
rooms     = ['single', 'doubles', 'triples', 'quadruples', 'quintuples', 'sextuples', 'children']

destinations.each do |destination|
  KepplerTravel::Destination.create(
    title: destination[:title],
    latitude: destination[:latitude],
    longitude: destination[:longitude],
    custom_title: destination[:custom_title],
    status: true
  )
  puts "Destination #{destination[:custom_title][:es]} has been created"
end

rankings.each do |name|
  KepplerTravel::Ranking.create(title: {en: name, es: name, pt: name})
  puts "Ranking #{name} has been created"
end

rooms.each do |name|
  KepplerTravel::Room.create type_room: name
  puts "Room #{name} has been created"
end

lodgments.each do |lodgment|
  KepplerTravel::Lodgment.create(
    title: {
      es: lodgment,
      en: lodgment,
      pt: lodgment
    },
    address: {
      es: 'Colombia',
      en: 'Colombia',
      pt: 'Colombia'
    },
    email: 'hotel@example.com',
    phone_one: 12345678,
    phone_two: 987654321,
    status: true,
    destination_id: [1, 2, 3].sample,
    ranking_id: [1, 2, 3, 4, 5].sample,
    room_ids: [1, 2, 3, 4, 5].sample
  )
  puts "Alojamiento #{lodgment} has been created"
end
