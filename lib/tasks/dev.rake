namespace :dev do
  desc 'Set up the development environment'
  task setup: :environment do
    if Rails.env.development? || Rails.env.test?
      show_successful_spinner('Deleting database...') { %x(rails db:drop) }
      show_successful_spinner('Creating database...') { %x(rails db:create) }
      show_successful_spinner('Migrating tables to database...') { %x(rails db:migrate) }
      %x(rails dev:create_one_user)
      %x(rails dev:create_some_students)
      %x(rails dev:create_some_addresses)
      %x(rails dev:create_some_phones)
    else
      show_error_spinner('Deleting database...', 'you must be using the development or test environment')
    end
  end

  desc 'Create one User'
  task create_one_user: :environment do
    user = {
      "email": Faker::Internet.free_email,
      "password": 12345678
    }
    show_successful_spinner('Creating one user...') do
      Login.create!(user)
    end
  end

  desc 'Create some students'
  task create_some_students: :environment do
    if Rails.env.development? || Rails.env.test?
      show_successful_spinner('Creating some Students...') do
        10.times do
          Student.create!(
            name: Faker::Name.name,
            father_name: Faker::Name.name,
            mother_name: Faker::Name.name,
            birth_date: Faker::Date.between(from: 20.years.ago, to: 5.years.ago)
          )
        end
      end
    else
      show_error_spinner('Creating some Students...', 'Error! You must be using the development or test environment')
    end
  end

  desc 'Create some addresses'
  task create_some_addresses: :environment do
    if Rails.env.development? || Rails.env.test?
      show_successful_spinner('Creating some Addresses...') do
        Student.all.each do |student|
          Address.create!(
            cep: '57052760',
            street: Faker::Address.street_address,
            number: Faker::Address.building_number,
            city: Faker::Address.city,
            uf: Faker::Address.country_code,
            complement: 'In front of the most hospital in the city',
            student_id: student.id
          )
        end
      end
    else
      show_error_spinner('Creating some Students...', 'Error! You must be using the development or test environment')
    end
  end

  desc 'Create some Phones'
  task create_some_phones: :environment do
    owners = %w[father mother home student grandfather grandmother]
    if Rails.env.development? || Rails.env.test?
      show_successful_spinner('Creating some Phones...') do
        Student.all.each do |student|
          Random.rand(5).times do
            phones = Phone.create!(
              number: Faker::PhoneNumber.cell_phone,
              number_owner: owners.sample,
              student_id: student.id
            )

            student.phones << phones
            student.save!
          end
        end
      end
    else
      show_error_spinner('Creating some Students...', 'Error! You must be using the development or test environment')
    end
  end

  private

  def show_successful_spinner(msg_initial, msg_end = 'Successful!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_initial}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  def show_error_spinner(msg_initial, msg_end = 'error!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_initial}")
    spinner.auto_spin
    spinner.error("(#{msg_end})")
  end
end
