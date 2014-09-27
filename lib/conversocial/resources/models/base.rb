module Conversocial
  module Resources
    module Models
      class Base
        def initialize params={}
          assign_attributes params
        end

        def assign_attributes params={}
          params.each do |k, v|
            send "#{k}=".to_sym, v
          end
        end

        def attributes
          self.class.fields.map do |field_name|
            [field_name, send(field_name.to_sym)]
          end.to_h
        end

        def refresh
          assign_attributes query_engine.find(id).attributes
        end

        protected

        def client
          @client
        end

        def assign_client v
          @client = v
        end

        def query_engine
          @query_engine
        end

        def assign_query_engine v
          @query_engine = v
        end

        def association_attribute? attribute_value
          if attribute_value.kind_of? Hash
            return true if attribute_value['url'].present?
          end
          false
        end



      end
    end
  end
end