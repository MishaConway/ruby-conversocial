module Conversocial
  module Resources
    module Models
      class Keyvalue < Base
        def self.fields
          %w{key value value_type}
        end

        attributize_tags
      end
    end
  end
end