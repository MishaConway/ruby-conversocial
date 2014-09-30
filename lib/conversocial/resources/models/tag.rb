module Conversocial
  module Resources
    module Models
      class Tag < Base
        def self.fields
          %w{id name url is_active}
        end

        attributize_tags
      end
    end
  end
end