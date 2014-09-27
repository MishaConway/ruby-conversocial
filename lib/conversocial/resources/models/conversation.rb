module Conversocial
  module Resources
    module Models
      class Conversation < Base
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

        fields.map(&:to_sym).each do |f|
          attr_writer f
          define_method f do
            value = instance_variable_get "@#{f}"
            if association_attribute? value
              value = client.send( "#{f}s".to_sym ).find value['id']
              puts "not value is #{value.inspect}"

              send "#{f}=".to_sym, value
            end
            value
          end
        end






      end
    end
  end
end