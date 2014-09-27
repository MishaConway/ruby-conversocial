module Conversocial
  module Resources
    module Models
      class Author < Base
        def self.fields
          %w{id url platform platform_id screen_name real_name location website description profile_picture profile_link}
        end
        attributize_tags

      end
    end
  end
end