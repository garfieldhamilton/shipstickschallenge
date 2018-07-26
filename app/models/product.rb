class Product
  include Mongoid::Document
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations

  field :name, type: String
  field :type, type: String
  field :length, type: Integer
  field :width, type: Integer
  field :height, type: Integer
  field :weight, type: Integer

  validates_presence_of :name, :type, :length, :width, :height, :weight

  validates_each :name, :type, :length, :width, :height, :weight do |record,attr,value|

#	Rails.logger.debug sprintf("CHECKING FIELD %s , %s",attr,value)

	record.errors.add attr,'is invalid' if value.nil?
  end

end
