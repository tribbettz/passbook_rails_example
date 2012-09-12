class Passbook::Registration < ActiveRecord::Base
  belongs_to :pass, class_name: "Passbook::Pass"

  validates_presence_of :device_library_identifier
  validates_uniqueness_of :device_library_identifier, scope: :pass_id

  attr_accessible :device_library_identifier, :push_token
end
