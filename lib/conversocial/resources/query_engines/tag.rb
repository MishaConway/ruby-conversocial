module Conversocial
  module Resources
    module QueryEngines
      class Tag < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Tag
        end
      end
    end
  end
end