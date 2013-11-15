namespace :db do
  desc "Fill database with sample data"
  def add_medicals(sheep, number)
      now = DateTime.now
      medical = sheep.medicals.new
      date = now << 3 + rand(70)
      weight = 3 + rand(4)
      medical.datetime = date
      medical.weight = weight
      medical.notes = "A new sheep is born!"
      sheep.birthyear = date.year
      medical.save
      number.times do
        days_since_last = now - date
        medical = sheep.medicals.new
        new_date = date + rand(days_since_last / 2)
        weight += (new_date - date) * 0.03
        date = new_date
        medical.datetime = date
        medical.weight = weight
        medical.notes = case rand(10)
        when 1..4 then "Routine weighing"
        when 5..7 then "Got a vaccination shot"
        when 8..9 then "Got a tetanus shot"
        end
        medical.save
      end
  end
  task populate: :environment do
    root = Farmer.create!(name: "Root",
                   email: "master@universe.com",
                   phone: "+4700000000",
                   password: "rootroot",
                   password_confirmation: "rootroot")
    sheep = root.sheep.new
    sheep_serial = 0
    sheep.serial = sheep_serial
    sheep.save
    add_medicals(sheep, 100)
    puts "Created Root Farmer"
    399.times do |n|
      name = Faker::Name.name
      email = "example-#{sprintf "%04d", n+1}@wolfbane.com"
      phone = sprintf "+47%08d", rand(10**8)
      backup = (n>0 && rand(3) == 0 ? "example-#{sprintf "%04d", 1+rand(n)}@wolfbane.com" : nil)
      password = "password"
      farmer = Farmer.create!(name: name,
                              email: email,
                              phone: phone,
                              backup: backup,
                              password: password,
                              password_confirmation: password)
      
      500.times do
        sheep = farmer.sheep.new
        sheep.serial = sheep_serial += 1

        add_medicals(sheep, 2 + rand(3) )

        pos = [63.6268, 11.5668]
        position = nil
        d = 0.0030
        10.times do
          pos.map! { |p| p + ((rand() * d) - d/2) }
          position = sheep.positions.new
          position.latitude = pos[0]
          position.longitude = pos[1]
          position.attacked = false
          position.save
        end
        sheep.latitude = position.latitude
        sheep.longitude = position.longitude
        sheep.attacked = position.attacked
        sheep.save
      end
    puts "Farmer created: #{farmer.email}"
    end
  end
end
