module Conversocial
  module Resources
    module Models
      class Account < Base
        def self.fields
          %w{url reports id channels description package created_date name}.map &:to_sym
        end
        attributize_tags



      end
    end
  end
end