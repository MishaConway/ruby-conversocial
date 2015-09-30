module Conversocial
  module Resources
    module Models
      class Content < Base
        def self.fields
          %w{attachments parent author user is_priority text tags sentiment channels platform platform_id link created_date type id is_private is_by_source}
        end
        attributize_tags

        def refresh
          self
        end
      end
    end
  end
end