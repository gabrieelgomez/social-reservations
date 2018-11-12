FactoryBot.define do
  factory :keppler_travel_license, class: 'KepplerTravel::License' do
    license { "MyString" }
    color { "MyString" }
  end
end
