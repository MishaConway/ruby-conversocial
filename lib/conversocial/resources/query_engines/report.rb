module Conversocial
  module Resources
    module QueryEngines
      class Report < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Report
        end
      end
    end
  end
end