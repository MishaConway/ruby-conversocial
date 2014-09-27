module Conversocial
  module Resources
    module QueryEngines
      class Account < Base


        def initialize client
          super client
          @query_params[:all][:is_priority] = 'false'
          @query_params[:all][:include]     = 'content'
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Account
        end



      end
    end
  end
end