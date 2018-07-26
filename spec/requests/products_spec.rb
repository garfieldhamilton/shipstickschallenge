# derived from https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

require 'rails_helper'

RSpec.describe 'Products API',type: :request do

	let!(:products) { create_list(:product,10) }
	let(:product_id) { products.first.id.to_s }

	# test GET /products
	describe 'GET /products' do
		before { get '/products' }

		it 'returns products'  do
			expect(json).not_to be_empty
			expect(json.size).to eq(10)
		end
		
		it 'returns status code 200' do
			expect(response).to have_http_status(200)
		end
	end

	# test GET /products/:id 
	describe 'GET /products/:id' do
		before { get "/products/#{product_id}" }
		
		context 'when the record exists' do
			it 'returns the product' do 
				expect(json).not_to be_empty
				expect(json['id']).to eq(product_id)
			end
		
			it 'returns status code 200' do
				expect(response).to have_http_status(200)
			end
		end


		context 'when the record odes not exist' do
			let(:product_id) { 100 }
			
			it 'returns status code 404' do
				expect(response).to have_http_status(404)
			end

			it 'returns a not found message' do 
				expect(response.body).to match(/Not Found/)
			end

		end
	end

	# test POST /products 
	describe 'POST /products' do
		let(:valid_attributes) {{ name: 'Test Luggage',type: 'Luggage',length:20,width:39,height:70,weight:50 }}
		
		context 'when the request is valid' do
			before { post '/products', params: valid_attributes }
		
			it 'creates a product' do 
				expect(json['name']).to eq('Test Luggage')
			end
			
			it 'returns status code 201' do
				expect(response).to have_http_status(201)
			end
		end
		
		context 'when the request is invalid' do
			before { post '/products',params: { name: 'Foobar'}}

			it 'returns status code 422' do 
				expect(response).to have_http_status(422)
			end

			it 'returns a validation failure message' do
				expect(response.body).to match(/Validation Failed/)
			end
		end
	end

	# test PUT /products/:id

	describe 'PUT /products/:id' do
		let(:valid_attributes) {{ name: 'Carry On' }}
		
		context 'when the record exists' do

			before { put "/products/#{product_id}",params: valid_attributes }
			it 'updates the record' do 
				expect(response.body).to be_empty
			end

			it 'returns status code 204' do
				expect(response).to have_http_status(204)
			end
		end
	end

	# test for DELETE /products/:id

	describe 'DELETE /products/:id' do

		before { delete "/products/#{product_id}" }

		it 'returns status code 204' do
			expect(response).to have_http_status(204)
		end
	end

end	

