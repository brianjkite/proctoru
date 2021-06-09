##
# On Create: write to the audit log what a Model's default values
# On Update: writes what the previous value and what new value was for each changed variable
#
# To control what the audit shows for a variable create an audits_formatting_values in the model that returns a hash with keys
# being the variable and set show => true/false if you want it to show.  If you want the variable to display differently than default set the title
#
# def audits_formatting_values
#    { 
#       prn: {title: 'As Needed?', show: true},
#       dc: {title: 'Discontinued Date', show: true},
#       created_at: {show: false}
#     }
# end
#
# To display nested attributes, create a function in the model called nested_attributes_audits.  Example below is for clinical_charts to also include
# the patient_time and electronic_visit_verification if those change
#
#  def nested_attributes_audits
#     [:patient_time, :electronic_visit_verification]
#  end
#


module ModelUpdateLoggingConcern
  extend ActiveSupport::Concern
  attr_accessor :on_created, :previous_values
  
  included do
    after_update :log_changes, if: :not_deleted?
    after_create :log_creation_values
  end
  
  def store_previous_values
    @previous_values = {}
    if self.respond_to?(:many_to_many_attributes_audits) && self.many_to_many_attributes_audits.present?
      self.many_to_many_attributes_audits.each do |attribute|
        @previous_values[attribute] = self.send("#{attribute.to_s.singularize}_ids")
      end
    end
  end

  protected

  def log_creation_values
    @on_created= true
    changes = self.changes.reject {|key, value| ['created_at', 'updated_at', 'model', 'additional_sections'].include?(key) }.collect  do |key, value|
      formatKeyValue(self, key, value)
    end.compact
    
    log_nested_object(self, changes)
    log_many_to_many_create(self, changes)

    Audit.log_event("Created #{to_s}: #{changes.join(', ')}", self.class.to_s.titleize)

  end

  def log_changes
    @on_created = false
    changes = self.changes.reject {|key, value| ['updated_at', 'model', 'additional_sections'].include?(key) }.collect  do |key, value|
      formatKeyValue(self, key, value)
    end.compact
    
    log_many_to_many_object_update(self, changes)
    log_nested_object(self, changes)
    
    Audit.log_event("Updated #{to_s}: #{changes.join(', ')} #{self.respond_to?(:additional_audit_information) ? self.additional_audit_information : nil}".strip, self.class.to_s.titleize, patient_identification, User.current)
  end
  
  def log_nested_object(object, changes)
    if object.respond_to?(:nested_attributes_audits) && object.nested_attributes_audits.present?
      object.nested_attributes_audits.each do |nested_attribute|
        nested_value = object.send(nested_attribute)
        next if nested_value.blank?
        #Check if it's a has_many or belongs_to, one class vs array of classes
        if nested_value.is_a?(Array) || nested_value.respond_to?(:count)
          nested_value.each do |nested_object|
            process_nested_object(nested_object, changes)
          end
        else
          process_nested_object(nested_value, changes)
        end
      end
    end
  end

  def log_many_to_many_create(object, changes)
    if object.respond_to?(:many_to_many_attributes_audits) && object.many_to_many_attributes_audits.present?
      object.many_to_many_attributes_audits.each do |attribute|
        values = object.send(attribute)
        if (values.present?)
          changes << "#{attribute} - #{values.collect {|v| v.to_s}}"
        end
      end
    end
  end

  def log_many_to_many_object_update(object, changes)
    if object.respond_to?(:many_to_many_attributes_audits) && object.many_to_many_attributes_audits.present? && self.previous_values
      object.many_to_many_attributes_audits.each do |attribute|
        new_value = object.send("#{attribute.to_s.singularize}_ids")
        if new_value != self.previous_values[attribute]
          changes << "#{attribute} - #{attribute.to_s.singularize.camelize.constantize.where(id: new_value).collect {|a| a.to_s}.join(', ')}"
        end
      end
    end
  end

  def process_nested_object(nested_object, changes)
    if nested_object.changes.present?
      nested_object_changes = nested_object.changes.reject {|key, value| key == 'updated_at' }.collect  do |key, value|
        formatKeyValue(nested_object, key, value)
      end

      changes << "#{nested_object.to_s} - ID #{nested_object.id}: #{nested_object_changes.join(', ')}"      
    end

    log_nested_object(nested_object, changes)
  end

  def formatValue(value)
     (value.to_s == "") ? "Blank" : value.to_s
  end

  def formatKeyValue(object, key, value)
    if object.respond_to?(:audits_formatting_values) && object.audits_formatting_values.present? and key_values = object.audits_formatting_values[key.to_sym] and key_values[:show].to_s.present? and !key_values[:show]
      nil
    else
      klass = key.slice('_id').present? ? key.gsub('_id', '').camelize : nil

      if klass.present? && Object.const_defined?("#{klass}")
        klass = klass.constantize
        title = if key_values.present?
          key_values[:title]
        else
          key.gsub('_id', '').humanize
        end 

        output = if @on_created
          "#{formatValue(klass.find_by(klass.primary_key => value[1]))}"
        else
          "#{formatValue(klass.find_by(klass.primary_key => value[0]))} to #{formatValue(klass.find_by(klass.primary_key => value[1]))}"
        end

        "#{title}: #{output}"
      elsif value[0].present? || value[1].present?

        output = if @on_created
          "#{formatValue(value[1])}"
        else
          "#{formatValue(value[0])} to #{formatValue(value[1])}"
        end

        "#{key_values.present? ? key_values[:title] : key.humanize}: #{output}"
      end
    end
  end

  def not_deleted?
    !self.respond_to?(:deleted_at) || deleted_at.blank?
  end
end