module Conversocial
  module Resources
    module QueryEngines
      class Conversation < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
        end

        def default_all_query_params
          {:is_priority => false, :include => 'content'}
        end


        protected

        def model_klass
          Conversocial::Resources::Models::Conversation
        end
      end
    end
  end
end