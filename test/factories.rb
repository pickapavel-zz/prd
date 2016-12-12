FactoryGirl.define do

  factory :user do
    name      { Faker::Name.name }
    sequence(:email) { |n| "#{Faker::Internet.user_name}#{n}@example.com" }
    password  'password'
  end

  factory :interface_cache do
    ic '12345678'
    source '{\"idUctovnychZavierok\":[259763,579784,945930,1674652,1974725,2487283,2968245,2961528],\"skNace\":\"70220\",\"konsolidovana\":false,\"ico\":\"12345678\",\"dic\":\"2021977947\",\"datumPoslednejUpravy\":\"2016-05-06\",\"zdrojDat\":\"ŠÚSR\",\"nazovUJ\":\"C.E.I. consulting a.s.\",\"mesto\":\"Bratislava-Ružinov\",\"ulica\":\"Bancíkovej 1/A\",\"psc\":\"82103\",\"datumZalozenia\":\"2005-03-22\",\"pravnaForma\":\"121\",\"velkostOrganizacie\":\"05\",\"druhVlastnictva\":\"2\",\"kraj\":\"1\",\"okres\":\"102\",\"sidlo\":\"529320\",\"id\":347679}'
  end

  factory :client do
    user
  end
end
