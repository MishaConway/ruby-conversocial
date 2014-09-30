module Conversocial
  module Resources
    module Models
      class User < Base
        def self.fields
          %w{id first_name last_name timezone date_joined last_login email account url}
        end

        attributize_tags
      end
    end
  end
end