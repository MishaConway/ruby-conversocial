module Conversocial
  module Resources
    module QueryEngines
      class Base
        include Enumerable

        attr_reader :client, :query_params

        def initialize client
          @client = client
          clear
        end

        def default_all_query_params
          {}
        end

        def default_find_query_params
          {}
        end

        def each &block
          all.each do |member|
            block.call(member)
          end
        end

        def each_page &block
          response = all_ex add_query_params("", default_all_query_params.merge(@query_params))
          begin
            continue = block.call response[:items]
            continue = true
            if continue
              next_page_url = (response[:json]['paging'] || {})['next_page']
              if next_page_url.present?
                response = all_ex next_page_url
              else
                response = nil
              end
            end
          end while response && continue
        end

        def clear
          @query_params = {}
          self
        end

        def where options
          @query_params.merge! options
          self
        end

        def new params={}
          new_instance = model_klass.new params
          new_instance.send :assign_client, client
          new_instance.send :assign_query_engine, self
          new_instance
        end

        def find find_id
          @query_params[:fields] ||= model_klass.fields.join(',')

          json = get_json add_query_params("/#{find_id}", default_find_query_params.merge(@query_params))
          clear
          new json[resource_name]
        end

        def all
          (all_ex add_query_params("", default_all_query_params.merge(@query_params)))[:items]
        end

        protected

        def all_ex url
          json = get_json url
          clear
          items = json[plural_resource_name].map do |instance_params|
            new instance_params
          end
          {:items => items, :json => json}
        end


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
          if path.match /^http/
            path.gsub /api.conversocial.com/, "#{client.key}:#{client.secret}@api.conversocial.com"
          else
            "https://#{client.key}:#{client.secret}@api.conversocial.com/v1.1#{base_path}#{path}"
          end
        end

        def get_json path
          puts "getting json for #{absolute_path(path)}"
          ::JSON.parse RestClient.get(absolute_path(path))
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