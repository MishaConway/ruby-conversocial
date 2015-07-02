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
          params.each { |k, v| send "#{k}=".to_sym, v }
        end

        def fields
          self.class.fields
        end

        def attributes mark_not_yet_loaded=true
          disable_association_resolving do
            self.class.fields.map do |field_name|
              val = send(field_name.to_sym)
              val = :not_yet_loaded if mark_not_yet_loaded && val.nil? && @loaded_attributes[field_name.to_sym].nil?
              [field_name, val]
            end.to_h
          end
        end

        def refresh
          disable_association_resolving do
            fully_loaded_instance = query_engine.find id
            if fully_loaded_instance
              assign_attributes fully_loaded_instance.attributes(false)
            else
              fields.each do |f|
                @loaded_attributes[f.to_sym] = 1
              end
            end
          end
          self
        end

        protected

        def disable_association_resolving
          @disable_association_resolving = true
          result = yield
          @disable_association_resolving = false
          result
        end

        def self.attributize_tags
          fields.map(&:to_sym).each do |f|
            #############################################
            #### define attribute writer for field  #####
            #############################################
            define_method "#{f}=".to_sym do |v|
              @loaded_attributes[f] = 1

              #if date or time attribute and value is a string parse as time
              if v.kind_of?(String)
                if %w{created date_to date_from date_joined last_login}.include?(f.to_s) || f.to_s.match(/date$/)
                  if v.match /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/
                    v = Date.parse v
                  else
                    v = Time.parse "#{v} UTC"
                  end
                end
              else
                if v.kind_of? Array
                  v = v.map do |vv|
                    if association_attribute? vv
                      client.send(pluralized_resource_type_from_association_attribute(vv).to_sym).new vv
                    else
                      vv
                    end
                  end
                end

                if association_attribute? v
                  v = client.send(pluralized_resource_type_from_association_attribute(v).to_sym).new v
                elsif :sentiment == f && v
                  v = query_engine.send :new_instance_of_klass, Conversocial::Resources::Models::Sentiment, v
                end
              end

              instance_variable_set "@#{f}", v
            end

            #############################################
            #### define attribute reader for field  #####
            #############################################
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
          attribute_value.kind_of?(Hash) && attribute_value.keys.sort == %w{id url}
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