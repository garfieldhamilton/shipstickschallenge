

# user this serializer to format our json object correctly
# we could use the jsonapi version by setting
# ActiveModel::Serializer.config.adapter = ActiveModel::Serializer::Adapter::JsonApi
# in config/initializers/active_model_serializers.rb
class ProductSerializer < ActiveModel::Serializer
	include NullAttributeRemover
	attributes :id, :name, :type, :length, :width, :height, :weight

	def id
		object['_id'].to_s
	end
end

class ProductsController < ApplicationController
	include Response

	skip_before_action :verify_authenticity_token

 	rescue_from (Mongoid::Errors::DocumentNotFound) do |ex|
        	render json: {error: 'Product Not Found'},status: :not_found
        end
	rescue_from (ActiveModel::ValidationError) do |ex|
                render json: {error: 'Validation Failed'},status: :unproccessable_entity
        end
	rescue_from (Mongoid::Errors::Validations) do |ex|
                render json: {error: 'Validation Failed'},status: :unproccessable_entity
        end
	rescue_from(ActionController::ParameterMissing) do |ex|
                render json: {error: 'Missing Parameters'},status: :unproccessable_entity
        end


	###########################################################
	## index
	## get a list of products that fit the specified criteria
	## products GET    /products(.:format)products#index
	###########################################################
	def index

		# do we have parameters
		permitted = params.permit([:length,:width,:height,:weight]).keys
		if permitted.length>0 && permitted.length<4
			render json: {error: "Missing Parameters"}, status: :unproccessable_entity
			return
		end

		products = []
		if(permitted.length == 0)
        	        dbproducts = Product.all
                	if !dbproducts.nil?
			# send back a clean object without dependencies on the 
			# mongodb ObjectId format.
                	        dbproducts.each do |dbproduct|
					products.push(dbproduct)
				end				
        	        end
		else
			dbproduct = Product.where(
				 { "$and": 
					[
						{ length: {"$gte": params[:length]}},
			                        { width:  {"$gte": params[:width]}}, 
						{ height: {"$gte": params[:height]}},
						{ weight: {"$gte": params[:weight]}}
					] 
				  })
				  .sort({ weight:1 })
				  .first
			if dbproduct.nil?
				return render json: {error: 'Product Not Found'}, status: :not_found
			else
				products.push dbproduct
			end
		end
			
                render json:  products, status: :ok 
	end

        ###########################################################
        ## create
        ## add a new product to the database with the criteria provided
        ## POST   /products(.:format)          products#create
        ###########################################################
	def create
		# we expect all object fields in the parameters
		# product will fail to validate if any field is invalid
		params.require([:name,:type,:length,:width,:height,:weight])
		
		product = Product.new
		product.name 	= params[:name] 
		product.type 	= params[:type]
		product.length 	= params[:length]
		product.width	= params[:width] 
		product.height	= params[:height]
		product.weight	= params[:weight]
		product.save!

		Rails.logger.debug sprintf("PRODUCT CLASS: %s",product.class)

		if !product.valid?
			render json: {status: 'Validation Failed' }, status: :unproccessable_entity
		else
			render json: product, status: :created
		end
	end	

        ###########################################################
        ## new
        ## generate the new product form
        ## GET    /products/new(.:format)      products#new
        ###########################################################
	def new
	
		
		render json: {}
	end
	
	###########################################################
        ## edit
        ## edit the product with the specified ID
        ## /products/:id/edit(.:format) products#edit
        ###########################################################
	def edit
		product_id = params[:id]
		product = Product.find_by(id: product_id)
		if product.nil?
			render json: {error: 'Product Not Found'}, status: :not_found
		else
		# render the edit form.
		end
	end

	###########################################################
        ## show
        ## retrieve the product with the specified ID
        ## GET    /products/:id(.:format)      products#show
        ###########################################################
	def show
		product_id = params[:id]
                product = Product.find_by(id: product_id)
		Rails.logger.debug sprintf("PRODUCTS.SHOW FOUND: %s",product.to_json)
                if product.nil?
                        render json: {error: 'Product Not Found'}, status: :not_found
                else
                        render json: product, status: :ok
                end
	end


	###########################################################
        ## update
        ## update the product with the provided ID
        ## PATCH  /products/:id(.:format)      products#update
	## PUT    /products/:id(.:format)      products#update
        ###########################################################
	def update
		product_id = params[:id]
		product = Product.find_by(id: product_id)
		if !product.nil?
			attributes=product.attributes
			params.each do |field_name|
				if attributes.has_key? field_name.to_s
					attributes[param] = params[field_name]
				end
				product.update_attributes attributes
			end
			head :no_content
		else
			render json: {error: 'Record Not Found'}, status: :not_found
		end
	end

	###########################################################
        ## destroy
        ## delete the product with the ID
        ## DELETE /products/:id(.:format)      products#destroy
        ###########################################################
        def destroy
		product_id = params[:id]
                product = Product.find_by(id: product_id)
		if !product.nil?
			product.destroy
		end
		head :no_content
        end

end
