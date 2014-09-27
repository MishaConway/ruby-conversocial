module Conversocial
  module Resources
    module QueryEngines
      class Keyvalue < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Keyvalue
        end
      end
    end
  end
end