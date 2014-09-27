module Conversocial
  module Resources
    module Models
      class Conversation




        def self.fields
          %w{id
url
status
is_priority
contains_private
tags
author
channels
assigned_to
content_ids
handling_times}.map &:to_sym
        end

        fields.each do |f|
          attr_accessor f.to_sym
        end


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
          assign_attributes @query_engine.find(id).attributes
        end

protected

        def query_engine
          @query_engine
        end

        def assign_query_engine v
          @query_engine = v
        end



      end
    end
  end
end