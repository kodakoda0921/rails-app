# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
@user = User.create!(name: "koda",
             email: "kodakoda@gmail.com",
             password: "11111111",
             password_confirmation: "11111111",
             activated: true,
             activated_at: Time.zone.now)
@user.build_profiles(job:"a")
@user.save
@user = User.create!(name: "bibi",
                     email: "bi@gmail.com",
                     password: "11111111",
                     password_confirmation: "11111111",
                     activated: true,
                     activated_at: Time.zone.now)
@user.build_profiles(job:"bibiWEB")
@user.save