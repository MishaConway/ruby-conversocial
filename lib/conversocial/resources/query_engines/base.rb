require 'net/http'

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

        def default_fetch_query_params
          {}
        end

        def default_find_query_params
          {}
        end

        def each &block
          fetch.each do |member|
            block.call(member)
          end
        end

        def each_page &block
          @query_params[:fields] ||= model_klass.fields.join(',')
          response = fetch_ex add_query_params("", default_fetch_query_params.merge(@query_params))
          begin
            continue = block.call response[:items]
            continue = true
            if continue
              next_page_url = (response[:json]['paging'] || {})['next_page']
              if next_page_url.present?
                response = fetch_ex next_page_url
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
          if json
            new json[resource_name]
          end
        end

        def size
          fetch.size
        end

        def count
          size
        end

        def last
          fetch.last
        end

        def fetch
          @query_params[:fields] ||= model_klass.fields.join(',')
          (fetch_ex add_query_params("", default_fetch_query_params.merge(@query_params)))[:items]
        end

        protected





        def fetch_ex url
          json = get_json url
          clear
          items = []
          if json
            items = json[plural_resource_name].map do |instance_params|
              new instance_params
            end
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
            path
          else
            "https://api.conversocial.com/v1.1#{base_path}#{path}"
          end
        end

        def get_json path
          puts "getting json for #{absolute_path(path)}"

          uri = URI absolute_path(path)
          response = Net::HTTP.start(uri.host, uri.port,
                          :use_ssl => uri.scheme == 'https',
                          :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

            request = Net::HTTP::Get.new uri.request_uri
            request.basic_auth client.key, client.secret

            http.request request # Net::HTTPResponse object
          end

          json = JSON.parse response.body

          if response.kind_of? Net::HTTPSuccess
            json
          else
            if 404 == response.code.to_i
              if json['message'] == "No such #{resource_name}"
                puts "returning nil here"
                return nil
              end
            end

            #some unknown error happened so raise standard exception
            raise Conversocial::Resources::Exceptions::Base.new response.code, response.message, json['message']
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