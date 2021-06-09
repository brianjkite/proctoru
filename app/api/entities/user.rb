class API::Entities::User < Grape::Entity
  expose :id,             documentation: {type: 'integer'}
  expose :first_name,     documentation: {type: 'string'}
  expose :last_name,      documentation: {type: 'string'}
  expose :phone_number,   documentation: {type: 'string'}
  expose :exams,          using: API::Entities::Exam
end