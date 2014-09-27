module Conversocial
  module Resources
    module Models
      class User < Base
        def self.fields
          %w{}
        end

        fields.each { |f| attr_accessor f }


      end
    end
  end
end