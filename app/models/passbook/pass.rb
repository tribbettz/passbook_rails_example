class Passbook::Pass < ActiveRecord::Base
  has_many :registrations, class_name: "Passbook::Registration"

  validates_presence_of :pass_type_identifier, :serial_number
  validates_uniqueness_of :pass_type_identifier
  validates_uniqueness_of :serial_number, scope: :pass_type_identifier

  attr_accessible :data, :pass_type_identifier, :serial_number

  def as_json(options = {})
    self.data || {}
  end
end
