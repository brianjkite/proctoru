class Audit < ActiveRecord::Base
  def self.log_event(event, event_type)
    create!({
      data: {
        category: event_type.to_s,
        description: event.to_s
      }
    })
  end

end