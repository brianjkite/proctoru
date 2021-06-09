class College < ActiveRecord::Base
  has_many :exams
  include ModelUpdateLoggingConcern
end