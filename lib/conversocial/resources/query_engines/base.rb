module Conversocial
  module Resources
    module QueryEngines
      class Base
        include Enumerable

        attr_reader :key, :secret, :query_params

        def initialize key, secret
          @key = key
          @secret = secret
          @query_params = {}
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

        protected

        def base_path
          raise "base_path must be implemented"
        end

        def absolute_path path
          "https://#{@key}:#{@secret}@api.conversocial.com/v1.1#{base_path}#{path}"
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

      end
    end
  end
end