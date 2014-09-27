module Conversocial
  module Resources
    module Models
      class Channel < Base
        def self.fields
          %w{created name url is_active id small_image reports fans account fb_page_url type}
        end
        fields.each{ |f| attr_accessor f }

      end
    end
  end
end