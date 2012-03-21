namespace :db do
  desc "Filling database with generated data..."
  task populate: :environment do
    admin_name = "tehadmin"
    admin_email = "something@somethingelse.com"
    admin_pass = "foobar"

    admin = User.create!(login: admin_name,
                         email: admin_email,
                         password: admin_pass,
                         password_confirmation: admin_pass)
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name[0, 20]
      email = "no#{n + 1}@missing.no"
      password = "password"
      print "\rUser: #{name.ljust(20)} : #{password}\t#{email}"
      User.create!(login: name, email: email, password: password, password_confirmation: password)
    end
    puts "\rAdmin: #{admin_name.ljust(20)} : #{admin_pass} \t#{admin_email}"
  end
end
