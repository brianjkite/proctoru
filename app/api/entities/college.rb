class API::Entities::College < Grape::Entity
  expose :id,             documentation: {type: 'integer'}
  expose :name,           documentation: {type: 'string'}
end