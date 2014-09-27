module Conversocial
  module Resources
    module QueryEngines
      class Channel < Base
        def initialize client
          super client
          #@query_params[:all][:is_priority] = 'false'
          #@query_params[:all][:include]     = 'content'
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Channel
        end

      end
    end
  end
end