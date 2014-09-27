module Conversocial
  module Resources
    module Models
      class Channel < Base
        def self.fields
          %w{created name url is_active id small_image reports fans account fb_page_url type}
        end
        attributize_tags

      end
    end
  end
end