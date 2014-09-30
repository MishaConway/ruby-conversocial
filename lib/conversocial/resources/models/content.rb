module Conversocial
  module Resources
    module Models
      class Content < Base
        def self.fields
          %w{attachments parent author is_priority text tags sentiment channels platform link created_date type id is_private}
        end
        attributize_tags




      end
    end
  end
end