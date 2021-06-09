class Exam < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :college
  has_one :exam_window

  accepts_nested_attributes_for :exam_window
  include ModelUpdateLoggingConcern
end