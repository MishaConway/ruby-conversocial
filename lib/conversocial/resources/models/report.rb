module Conversocial
  module Resources
    module Models
      class Report < Base
        def self.fields
          %w{account name generation_start_date url date_from generated_by id failure generated_date date_to download date_type}
        end

        attributize_tags


      end
    end
  end
end