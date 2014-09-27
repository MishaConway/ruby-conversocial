module Conversocial
  module Resources
    module QueryEngines
      class Base
        include Enumerable

        attr_reader :client, :query_params

        def initialize client
          @client = client
          @query_params = {:all => {}, :find => {}}
        end

        def each &block
          all.each do |member|
            block.call(member)
          end
        end

        def limit l
          @query_params[:all][:page_size] = l
          self
        end

        def where options
          @query_params[:all][:options].merge! options
          self
        end

        def new params={}
          new_instance = model_klass.new params
          new_instance.send :assign_client, client
          new_instance.send :assign_query_engine, self
          new_instance
        end

        def find find_id, options={}
          @query_params[:find][:fields] ||= model_klass.fields.join(',')

          json = get_json add_query_params("/#{find_id}", @query_params[:find])
          new json[resource_name]
        end

        def all
          json = get_json add_query_params("", @query_params[:all])
          response = json[plural_resource_name].map do |instance_params|
            new instance_params
          end
        end

        protected

        def resource_name
          demodulize(model_klass.name).downcase
        end

        def plural_resource_name
          resource_name + 's'
        end

        def base_path
          "/" + plural_resource_name
        end

        def absolute_path path
          "https://#{client.key}:#{client.secret}@api.conversocial.com/v1.1#{base_path}#{path}"
        end

        def get_json path
          puts "getting json for #{absolute_path(path)}"
          begin
            ::JSON.parse RestClient.get(absolute_path(path))
          rescue Exception => e
            e
          end
        end

        def add_query_params(url, params_to_add)
          uri    = URI url
          params = (params_to_add || {}).merge URI.decode_www_form(uri.query.to_s).to_h
          return url if params.blank?
          uri.query = URI.encode_www_form(params)
          uri.to_s
        end

        def demodulize(path)
          path = path.to_s
          if i = path.rindex('::')
            path[(i+2)..-1]
          else
            path
          end
        end

      end
    end
  end
end