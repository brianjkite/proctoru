class ApiV1::Entities::Exam < Grape::Entity
  expose :id,             documentation: {type: 'integer'}
  expose :title,          documentation: {type: 'string'}
  expose :college,        using: ApiV1::Entities::College
end