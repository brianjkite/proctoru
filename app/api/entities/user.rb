class ApiV1::Entities::User < Grape::Entity
  expose :id,             documentation: {type: 'integer'}
  expose :first_name,     documentation: {type: 'string'}
  expose :last_name,      documentation: {type: 'string'}
  expose :phone_number,   documentation: {type: 'string'}
  expose :exams,          using: ApiV1::Entities::Exam
end