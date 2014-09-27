module Conversocial
  module Resources
    module QueryEngines
      class Channel < Base
        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Channel
        end

      end
    end
  end
end