module Conversocial
  module Resources
    module QueryEngines
      class User < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::User
        end
      end
    end
  end
end