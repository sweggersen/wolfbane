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
      farmer = Farmer.create!(name: name,
                              email: email,
                              phone: phone,
                              backup: backup,
                              password: password,
                              password_confirmation: password)
      
      next # remove this to create sheep etc
      100.times do
        serial = sprintf "04d", rand(10**4)
        sheep = Sheep.create!(serial: serial,
                              farmer: farmer)
        now = DateTime.now
        date = now << 3 + rand(70)
        weight = 3 + rand(4)
        note = "A new sheep is born!"
        Medicals.create!(datetime: date,
                         weight: weight,
                         notes: note,
                         sheep_id: sheep.id)
        5.times do
          days_since_last = now - date
          break if days_since_last < 3
          date = date + rand(days_since_last)
          weight = weight + days_since_last * 0.03
          note = case rand(20)
          when 0..4 then "Routine weighing"
          when 5..7 then "Got a vaccination shot"
          when 8..9 then "Got a tetanus shot"
          when 10 then "Got an anal bleaching"
          else next
          end
          Medicals.create!(datetime: date,
                           weight: weight,
                           notes: note,
                           sheep_id: sheep.id)
        end

      end


    end
  end
end
