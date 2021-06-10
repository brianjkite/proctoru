# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(first_name: "Ferris", last_name: "Bueller", phone_number: "9198675309")
college = College.create(name: "Appalachian State University")
exam = Exam.create(title: 'CS 101', college: college, exam_window_attributes: {start_time_window: Time.zone.now, end_time_window: Time.zone.now + 1.week})