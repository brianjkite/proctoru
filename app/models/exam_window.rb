class ExamWindow < ActiveRecord::Base
  belongs_to :exam
  include ModelUpdateLoggingConcern
end