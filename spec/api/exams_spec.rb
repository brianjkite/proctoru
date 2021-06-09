require 'rails_helper'

describe 'Exams API' do
  describe 'GET /exams' do
    context "success" do
      before(:each) do
        @college = College.first || create(:college)
        @exam = @college.exams.first || create(:exam, college: @college)
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
      end
    end
  end
end