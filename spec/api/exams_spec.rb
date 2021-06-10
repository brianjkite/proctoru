require 'rails_helper'

describe 'Exams API' do
  describe 'GET /exams' do
    before(:each) do
      @college = College.first || create(:college)
      @exam = @college.exams.first || create(:exam, college: @college)
      @exam_window = create(:exam_window, exam: @exam)
    end

    context "success" do
      it "should return 200" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: @college.id,
          exam_id: @exam.id,
          start_time: Time.zone.now
        }
        expect(response.status).to eq 201
      end

      it "should return 200 when user exists" do
        user = create(:user)
        post '/api/exams', params: {
          first_name: user.first_name,
          last_name: user.last_name,
          phone_number: user.phone_number,
          college_id: @college.id,
          exam_id: @exam.id,
          start_time: Time.zone.now
        }
        expect(response.status).to eq 201
      end
    end

    context "breakage" do
      it "should return 400 for no college" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: 15,
          exam_id: 15,
          start_time: Time.zone.now
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to  eq "College does not exist"
      end

      it "should return 400 for no exam" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: create(:college).id,
          exam_id: 15,
          start_time: Time.zone.now
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to  eq "Exam does not exist"
      end

      it "should return 400 for outside window" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: @college.id,
          exam_id: @exam.id,
          start_time: Time.zone.now - 2.days
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to  eq "Start time is not in the exam window"
      end

      it "should return an error when exam doesn't match college" do
        exam = create(:exam, college: create(:college))
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: create(:college).id,
          start_time: Time.zone.now,
          exam_id: exam.id
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)).to  eq "Exam does not belong to college"
      end

      it "should return 400 for no exam param passed" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: create(:college).id,
          start_time: Time.zone.now
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)["error"]).to eq "exam_id is missing"
      end

      it "should return 400 for no first name passed" do
        post '/api/exams', params: {
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: create(:college).id,
          start_time: Time.zone.now,
          exam_id: @exam.id
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)["error"]).to  eq "first_name is missing"
      end

      it "should return 400 for missing phone number passed" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          college_id: create(:college).id,
          start_time: Time.zone.now,
          exam_id: @exam.id
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)["error"]).to  eq "phone_number is missing"
      end
    end
  end
end