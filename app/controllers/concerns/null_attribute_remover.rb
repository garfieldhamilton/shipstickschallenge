module NullAttributeRemover

 	def serializable_hash(adapter_options=nil,
                options={},
                adapter_instance = self.class.serialization_adapter_instance)
                hash = super

                #Rails.logger.debug sprintf("SERIALIZABLE HASH %s",hash.to_json)

                hash.each { |key,value| hash.delete(key) if value.nil? }
                hash
        end
end
