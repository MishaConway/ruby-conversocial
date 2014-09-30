module Conversocial
  module Resources
    module QueryEngines
      class Conversation < Base
        include Conversocial::Resources::QueryEngines

        def initialize client
          super client
        end

        def default_fetch_query_params
          {:is_priority => false, :include => 'content'}
        end

        def default_find_query_params
          {:include => 'content'}
        end

        def limit l
          where :page_size => l
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Conversation
        end
      end
    end
  end
end