module Conversocial
  module Resources
    module QueryEngines
      class Conversation < Base
        include Conversocial::Resources::QueryEngines

        def initialize key, secret
          super key, secret
          @query_params = {:all => {}, :find => {}}
          @query_params[:all][:is_priority] = 'false'
          @query_params[:all][:include] = 'content'
        end

        def new params={}
          new_instance = model_klass.new params
          new_instance.send :assign_query_engine, self
          new_instance
        end

        def find find_id, options={}
          @query_params[:find][:fields] ||= model_klass.fields.join(',')

          json = get_json add_query_params("/#{find_id}", @query_params[:find])
          new json['conversation']
        end

        def all
          json = get_json add_query_params("", @query_params[:all])
          response = json['conversations'].map do |conversation_json|
            new conversation_json
          end
        end





        protected

        def model_klass
          Conversocial::Resources::Models::Conversation
        end

        def base_path
          "/conversations"
        end
      end
    end
  end
end