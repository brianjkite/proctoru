class ExamWindow < ActiveRecord::Base
  include ModelUpdateLoggingConcern
  belongs_to :exam
end