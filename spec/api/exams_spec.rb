require 'rails_helper'

describe 'Exams API' do
  describe 'GET /exams' do
    context "success" do
      before(:each) do
        @college = College.first || create(:college)
        @exam = @college.exams.first || create(:exam, college: @college)
        @exam_window = create(:exam_window, exam: @exam)
      end

      it "should return 200" do
        post '/api/exams', params: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          phone_number: Faker::PhoneNumber.phone_number,
          college_id: @college.id,
          exam_id: @exam.id,
          start_time: Time.zone.now
        }
        response.status.should eq 201
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
        response.status.should eq 201
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
        response.status.should eq 400
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
        response.status.should eq 400
      end
    end
  end
end