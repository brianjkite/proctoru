class Exam < ActiveRecord::Base
  has_one :exam_window
  has_and_belongs_to_many :users
  belongs_to :college
  include ModelUpdateLoggingConcern
end