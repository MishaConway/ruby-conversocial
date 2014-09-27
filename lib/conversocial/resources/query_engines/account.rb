module Conversocial
  module Resources
    module QueryEngines
      class Account < Base


        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Account
        end



      end
    end
  end
end