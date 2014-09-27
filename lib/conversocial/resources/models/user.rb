module Conversocial
  module Resources
    module Models
      class User < Base
        def self.fields
          %w{id first_name last_name timezone date_joined last_login email account url}
        end

        fields.each { |f| attr_accessor f }


      end
    end
  end
end