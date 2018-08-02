#class TestingSerializer < ActiveModel::Serializer
#        include NullAttributeRemover
#        attributes :id, :name, :type, :length, :width, :height, :weight
#end



class TestingController < ApplicationController

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
		  
		# {error: 'Missing Parameters'}
                render json: ex ,status: :unproccessable_entity
        end

	

	def index
		params.require([:name,:type,:length,:width,:height,:weight])		

		render json: {status: 'this is the result'}, status: :ok
	end
end
