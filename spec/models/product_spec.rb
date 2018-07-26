require 'rails_helper'



RSpec.describe Product,type: :model do
	
	# validation test
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:type) }
	it { should validate_presence_of(:length) }
	it { should validate_presence_of(:width) }
	it { should validate_presence_of(:height) }
	it { should validate_presence_of(:weight) }
end
