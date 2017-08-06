# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create email: "admin@gmail.com", password: "password", role: 0
Admin.create email: "qc@gmail.com", password: "password", role: 1
Admin.create email: "qb@gmail.com", password: "password", role: 2
User.create email: "user@gmail.com", password: "password"

# 1000.times do |i|
#   User.create(name: FFaker::Name.name, email: "#{i}#{FFaker::Internet.email}", password: "password")
# end
# 100.times do |i|
#   Client.create name: "#{FFaker::Product.brand}#{i}"
# end
# 1000.times do |i|
#   Project.create name: "#Project [#{i}]", patitent_num: rand(100),
#                                           short_name: "project_#{i}",
#                                           period_start_date: FFaker::Time.date,
#                                           period_end_date: FFaker::Time.date,
#                                           client_id: (rand(12) + 1)
# end

# Table.destroy_all
# Column.destroy_all
# Row.destroy_all

table = Table.create name: "Test4", project_id: 1

columns = [
          {name: "name", content_type: "string"},
           {name: "weight", content_type: "float"},
           {name: "age", content_type: "integer"},
           {name: "height", content_type: "float"},
           {name: "email", content_type: "string"},
           {name: "password", content_type: "string"},
           {name: "DOCTOR1", content_type: "string"},
           {name: "DOCTOR2", content_type: "string"},
           {name: "DOCTOR3", content_type: "string"},
           {name: "DOCTOR4", content_type: "string"},
           {name: "DOCTOR5", content_type: "string"},
           {name: "DOCTOR6", content_type: "string"},
           {name: "DOCTOR7", content_type: "string"},
           {name: "DOCTOR8", content_type: "string"},
           {name: "DOCTOR9", content_type: "string"},
           {name: "DOCTOR10", content_type: "string"}
          # {name: "DOCTOR11", content_type: "string"},
          # {name: "DOCTOR12", content_type: "string"},
          # {name: "DOCTOR13", content_type: "string"},
          # {name: "DOCTOR14", content_type: "string"},
          # {name: "DOCTOR15", content_type: "string"},
          # {name: "DOCTOR16", content_type: "string"},
          # {name: "DOCTOR17", content_type: "string"},
          # {name: "DOCTOR18", content_type: "string"},
          # {name: "DOCTOR19", content_type: "string"},
          # {name: "DOCTOR20", content_type: "string"},
          # {name: "DOCTOR21", content_type: "string"},
          # {name: "DOCTOR22", content_type: "string"},
          # {name: "DOCTOR23", content_type: "string"},
          # {name: "DOCTOR24", content_type: "string"},
          # {name: "DOCTOR25", content_type: "string"},
          # {name: "DOCTOR26", content_type: "string"},
          # {name: "DOCTOR27", content_type: "string"},
          # {name: "DOCTOR28", content_type: "string"},
          # {name: "DOCTOR29", content_type: "string"},
          # {name: "DOCTOR30", content_type: "string"},

].each { |e| e[:table_id] = 13}

column_ids = columns.map{ |e| Column.create e}.pluck(:id)


1000.times do
  params = {table_id: 13, row_data: []}
  params[:row_data].push(name: FFaker::Name.name)
  params[:row_data].push(weight: rand(70..85))
  params[:row_data].push(age: rand(20..28))
  params[:row_data].push(height: rand(160..180))
  params[:row_data].push(password: FFaker::Name.name)
  params[:row_data].push(email: FFaker::Name.name)
  params[:row_data].push(DOCTOR1: FFaker::Name.name)
  params[:row_data].push(DOCTOR2: FFaker::Name.name)
  params[:row_data].push(DOCTOR3: FFaker::Name.name)
  params[:row_data].push(DOCTOR4: FFaker::Name.name)
  params[:row_data].push(DOCTOR5: FFaker::Name.name)
  params[:row_data].push(DOCTOR6: FFaker::Name.name)
  params[:row_data].push(DOCTOR7: FFaker::Name.name)
  params[:row_data].push(DOCTOR8: FFaker::Name.name)
  params[:row_data].push(DOCTOR9: FFaker::Name.name)
  params[:row_data].push(DOCTOR10: FFaker::Name.name)
  # params[:row_data].push(DOCTOR21: FFaker::Name.name)
  # params[:row_data].push(DOCTOR22: FFaker::Name.name)
  # params[:row_data].push(DOCTOR23: FFaker::Name.name)
  # params[:row_data].push(DOCTOR24: FFaker::Name.name)
  # params[:row_data].push(DOCTOR25: FFaker::Name.name)
  # params[:row_data].push(DOCTOR26: FFaker::Name.name)
  # params[:row_data].push(DOCTOR27: FFaker::Name.name)
  # params[:row_data].push(DOCTOR28: FFaker::Name.name)
  # params[:row_data].push(DOCTOR29: FFaker::Name.name)
  # params[:row_data].push(DOCTOR30: FFaker::Name.name)
  # params[:row_data].push(DOCTOR11: FFaker::Name.name)
  # params[:row_data].push(DOCTOR12: FFaker::Name.name)
  # params[:row_data].push(DOCTOR13: FFaker::Name.name)
  # params[:row_data].push(DOCTOR14: FFaker::Name.name)
  # params[:row_data].push(DOCTOR15: FFaker::Name.name)
  # params[:row_data].push(DOCTOR16: FFaker::Name.name)
  # params[:row_data].push(DOCTOR17: FFaker::Name.name)
  # params[:row_data].push(DOCTOR18: FFaker::Name.name)
  # params[:row_data].push(DOCTOR19: FFaker::Name.name)
  # params[:row_data].push(DOCTOR20: FFaker::Name.name)
  Row.create_record params
end
#
#
# Row.joins(:cells).where()
