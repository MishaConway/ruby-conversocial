module Conversocial
  module Resources
    module QueryEngines
      class Account
        def self.fields
          %w{url reports id channels description package created_date name}.map &:to_sym
        end

        fields.each { |f| attr_accessor f }


      end
    end
  end
end