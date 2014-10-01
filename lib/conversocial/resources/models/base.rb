module Conversocial
  module Resources
    module Models
      class Base
        include Conversocial::Utils::Strings

        attr_reader :loaded_attributes, :contents

        def initialize params={}
          disable_association_resolving do
            @loaded_attributes = {}
            @contents = []
            assign_attributes params
          end
        end

        def inspect
          attr_list = attributes.map { |k,v| "#{k}: #{v}" } * ', '
          "#<#{self.class.name}(#{attr_list})>"
        end

        def assign_attributes params={}
          params.each do |k, v|
            send "#{k}=".to_sym, v
          end
        end

        def fields
          self.class.fields
        end

        def attributes mark_not_yet_loaded=true
          inspect_unloaded_association = ->(v) do
            "#<#{singularized_resource_type_from_association_attribute(v).capitalize}(id: #{v['id']})>"
          end


          attrs = nil
          disable_association_resolving do
            attrs = self.class.fields.map do |field_name|
              val = send(field_name.to_sym)
              if mark_not_yet_loaded
                if val.nil? && @loaded_attributes[field_name.to_sym].nil?
                  val = :not_yet_loaded
                elsif association_attribute? val
                  val = inspect_unloaded_association.call val
                elsif val.kind_of? Array
                  val = val.map do |v|
                    if association_attribute? v
                      inspect_unloaded_association.call v
                    else
                      v
                    end
                  end
                end
              end
              [field_name, val]
            end.to_h
          end
          attrs
        end

        def refresh
          disable_association_resolving do
            assign_attributes query_engine.find(id).attributes(false)
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

              #if date or time attribute and value is a string parse as time
              if v.kind_of?(String)
                if %w{created date_to date_from date_joined last_login}.include?(f.to_s) || f.to_s.match(/date$/)
                  if v.match /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/
                    v = Date.parse v
                  else
                    v = Time.parse v
                  end
                end
              end

              instance_variable_set "@#{f}", v
            end


            define_method f do
              value = instance_variable_get "@#{f}"
              unless @disable_association_resolving
                #lazily load in value if it hasn't been loaded yet
                if value.nil?
                  unless @loaded_attributes[f]
                    refresh
                    value = instance_variable_get "@#{f}"
                  end
                end

                #lazily load association if it hasn't been loaded yet
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

        def append_content content
          @contents << content
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

        def singularized_resource_type_from_association_attribute attribute_value
          pluralized_resource_type_from_association_attribute(attribute_value).chop
        end

        def load_association value
          client.send(pluralized_resource_type_from_association_attribute(value).to_sym).find value['id']
        end
      end
    end
  end
end