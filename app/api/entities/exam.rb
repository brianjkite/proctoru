class API::Entities::Exam < Grape::Entity
  expose :id,             documentation: {type: 'integer'}
  expose :title,          documentation: {type: 'string'}
  expose :college,        using: API::Entities::College
end