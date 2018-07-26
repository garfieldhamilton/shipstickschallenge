FactoryBot.define do
	factory :product do
		name { Faker::Lorem.word }
		type { ['Ski','Luggage','Golf'].sample }
		length { Faker::Number.between(25,100) }
		width { Faker::Number.between(12,30) }
		height { Faker::Number.between(7,80) }
		weight { Faker::Number.between(25,75) }
	end
end

