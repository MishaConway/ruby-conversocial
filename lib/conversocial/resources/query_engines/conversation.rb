module Conversocial
  module Resources
    module QueryEngines
      class Conversation < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
          @query_params[:all][:is_priority] = 'false'
          @query_params[:all][:include] = 'content'
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Conversation
        end
      end
    end
  end
end