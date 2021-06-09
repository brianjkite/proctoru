class API < Grape::API
  version 'v1', using: :header, vendor: 'proctoru'
  format :json
  prefix :api
  
  resource :exams do
    desc "Assign a user to an exam"
    params do
      requires :first_name, type: String
      requires :last_name, type: String
      requires :phone_number, type: String
      requires :college_id, type: Integer
      requires :exam_id, type: Integer
      requires :start_time, type: DateTime
    end
    post do
      safe_params = BackwordsCompatParams.new(declared(params, include_missing: false)).to_hash(symbolize_keys: true)
      exam, errors = ExamService.new(safe_params).validate
      if exam.save
        
      else

      end
    end
  end
end

class BackwordsCompatParams < Hashie::Mash
  disable_warnings
end