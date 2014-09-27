module Conversocial
  module Resources
    module Models
      class Base
        attr_reader :loaded_attributes

        def initialize params={}
          disable_association_resolving do
            @loaded_attributes = {}
            assign_attributes params
          end
        end

        def assign_attributes params={}
          params.each do |k, v|
            send "#{k}=".to_sym, v
          end
        end

        def attributes
          attrs = nil
          disable_association_resolving do
            attrs = self.class.fields.map do |field_name|
              [field_name, send(field_name.to_sym)]
            end.to_h
          end
          attrs
        end

        def refresh
          disable_association_resolving do
            assign_attributes query_engine.find(id).attributes
          end
          self
        end

        protected

        def disable_association_resolving
          @disable_association_resolving = true
          yield
          @disable_association_resolving = false
        end

        def self.attributize_tags
          fields.map(&:to_sym).each do |f|

            define_method "#{f}=".to_sym do |v|
              @loaded_attributes[f] = 1
              instance_variable_set "@#{f}", v
            end


            define_method f do
              value = instance_variable_get "@#{f}"
              unless @disable_association_resolving
                if value.nil?
                  unless @loaded_attributes[f]
                    refresh
                    value = instance_variable_get "@#{f}"
                  end
                end

                if value.kind_of? Array
                  value = value.map do |v|
                    if association_attribute? v
                      load_association v
                    else
                      v
                    end
                  end
                  send "#{f}=".to_sym, value
                else
                  value = load_association value if association_attribute? value
                  send "#{f}=".to_sym, value
                end
              end
              value
            end
          end
        end


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

        def pluralized_resource_type_from_association_attribute attribute_value
          attribute_value['url'].split('v1.1/').last.split('/').first
        end

        def load_association value
          client.send(pluralized_resource_type_from_association_attribute(value).to_sym).find value['id']
        end


      end
    end
  end
end