require 'json'


product_file_path = Rails.root.join("lib","seeds","products.json")
if(File.exists? product_file_path)
	
	product_set = JSON.parse(File.read(product_file_path))
	if(!product_set.nil?)
		products = product_set["products"]
		if(!products.nil?)
			products.each do |product|


				dbproduct = Product.find_by(name: product["name"])
				
				if(dbproduct.nil?)
					dbproduct = Product.new({
						name: 	product["name"],
						type: 	product["type"],
						length: product["length"],
						width: 	product["width"],
						height: product["height"],
						weight: product["weight"]	
					})
					dbproduct.save

					Rails.logger.debug sprintf("SAVING PRODUCT: %s",product.to_json)
				else
					Rails.logger.debug sprintf("PRODUCT EXISTS: %s",dbproduct.to_json);
				end
			end
		end
	end	
	
	
end
