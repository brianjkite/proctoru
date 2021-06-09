FactoryBot.define do
  factory :exam_window do
    start_time_window  { Date.today - 1.hour}
    end_time_window    { Date.today + 1.day}
  end
end