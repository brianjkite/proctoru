class ExamService
  attr_reader :params, :college, :exam
  def initialize(params)
    @params = params
  end


  def validate
    return nil, "College does not exist" unless college_exists
    return nil, "Exam does not exist" unless exam_exists
    user = upsert_user
    return nil, "Start time is not in the exam window" unless validate_start_time
  end

  def college_exists
    @college = College.find(params[:college_id]).present?
    @college
  end

  def exam_exists
    @exam = Exam.find(params[:exam_id]).present?
    @exam
  end

  def upsert_user
    user = User.where(first_name: params[:first_name], last_name: params[:last_name], phone_number: params[:phone_number]).first
    return user if user.present?
    User.create(first_name: params[:first_name], last_name: params[:last_name], phone_number: params[:phone_number])
  end

  def validate_start_time
    params[:start_time].to_date.between(@exam.exam_window.start_time, @exam.exam_window.end_time)
  end
end