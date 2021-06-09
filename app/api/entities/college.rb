class ApiV1::Entities::College < Grape::Entity
  expose :id,             documentation: {type: 'integer'}
  expose :name,           documentation: {type: 'string'}
end