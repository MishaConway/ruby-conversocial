module Conversocial
  module Resources
    module Models
      class Tag < Base
        def self.fields
          %w{id name url is_active}
        end

        fields.each { |f| attr_accessor f }


      end
    end
  end
end