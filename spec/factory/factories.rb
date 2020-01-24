FactoryBot.define do
  owners = %w[father mother home student grandfather grandmother]

  factory :create_login, class: Login do
    email { 'adm@adm.com' }
    password { '123456' }
  end

  factory :random_student, class: Student do
    name { Faker::Name.name }
    father_name { Faker::Name.name }
    mother_name { Faker::Name.name }
    birth_date { Faker::Date.between(from: 20.years.ago, to: 5.years.ago) }
  end

  factory :random_address, class: Address do
    cep { Faker::Number.number(digits: 8).to_s }
    street { Faker::Address.street_address }
    number { Faker::Address.building_number }
    city { Faker::Address.city }
    uf { Faker::Address.country_code }
    complement { Faker::Lorem.paragraph_by_chars(number: 100, supplemental: false) }
    student_id { Student.all.sample.id }
  end

  factory :random_phone, class: Phone do
    number { Faker::PhoneNumber.cell_phone }
    number_owner { owners.sample }
    student_id { Student.all.sample.id }
  end
end
