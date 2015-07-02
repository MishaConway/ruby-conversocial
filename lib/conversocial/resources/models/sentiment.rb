module Conversocial
  module Resources
    module Models
      class Sentiment < Base
        def self.fields
          %w{created_by value}
        end
        attributize_tags

        def refresh
          self
        end
      end
    end
  end
end