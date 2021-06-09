FactoryBot.define do
  factory :exam_window do
    exam               { Exam.first || create(:exam)}
    start_time_window  { Date.today - 1.hour}
    end_time_window    { Date.today + 1.day}
  end
end