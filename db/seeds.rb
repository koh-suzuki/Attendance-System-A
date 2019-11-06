# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             affiliation: "フリーランス部",
             employee_number: 1,
             uid: "1",
             superior: false,
             admin: true,
             )

User.create!(name: "Superior User",
             email: "superior@email.com",
             password: "password",
             affiliation: "フリーランス部",
             employee_number: 2,
             uid: "2",
             basic_time: Time.current.change(hour: 8, min: 0, sec: 0),
             designated_work_start_time: Time.current.change(hour: 22, min: 0, sec: 0),
             designated_work_end_time: Time.current.change(hour: 5, min: 0, sec: 0),
             superior: true,
             admin: false)
             
60.times do |n|
  name = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password)
end               