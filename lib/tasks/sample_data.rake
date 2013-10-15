namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Farmer.create!(name: "Root",
                   email: "master@universe.com",
                   phone: "+4700000000",
                   password: "rootroot",
                   password_confirmation: "rootroot")
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@wolfbane.com"
      phone = sprintf "+47%08d", rand(10**8)
      backup = (n>0 && rand(3) == 0 ? "example-#{1+rand(n)}@wolfbane.com" : nil)
      password = "password"
      Farmer.create!(name: name,
                     email: email,
                     phone: phone,
                     backup: backup,
                     password: password,
                     password_confirmation: password)
    end
  end
end
