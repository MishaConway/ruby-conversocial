require 'net/http'

module Conversocial
  module Resources
    module QueryEngines
      class Base
        include Enumerable
        include Conversocial::Utils::Strings
        include Conversocial::Utils::HTTP

        attr_reader :client, :query_params

        def initialize client
          @client = client
          @cache  = Conversocial::Resources::QueryEngines::Cache.new client.cache_expiry
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
          options = options.map do |k, v|
            v = v.utc.strftime '%Y-%m-%dT%H:%M:%S' if v.kind_of? Time
            v = v.to_s if v.kind_of? Date
            [k, v]
          end.to_h

          @query_params.merge! options
          self
        end

        def find find_id

            @query_params[:fields] ||= model_klass.fields.join(',')

            json = get_json add_query_params("/#{find_id}", default_find_query_params.merge(@query_params))
            clear
            if json
              item = new json[resource_name]
              attach_content_to_items([item], json['content']).first
            end

        end

        def size
          fetch.size
        end

        alias :count :size

        def last
          fetch.last
        end

        def fetch
          @query_params[:fields] ||= model_klass.fields.join(',')
          (fetch_ex add_query_params("", default_fetch_query_params.merge(@query_params)))[:items]
        end


        def sort field
          field = field.join ',' if field.kind_of? Array
          where :sort => field
        end

        alias :sort_by :sort
        alias :order :sort
        alias :order_by :sort

        def select *fields
          where :fields => fields
        end

        def greater_than field, value
          comparison_filter field, "gt", value
        end

        def greater_than_or_equal_to field, value
          comparison_filter field, "gte", value
        end

        def lesser_than field, value
          comparison_filter field, "lt", value
        end

        def less_than_or_equal_to field, value
          comparison_filter field, "lte", value
        end

        def is_nil field
          comparison_filter field, "isnull", 1
        end

        def is_not_nil field
          comparison_filter field, "isnull", 0
        end

        def to_fetch_url
          absolute_path add_query_params("", default_fetch_query_params.merge(@query_params))
        end

        def new params={}
          new_instance_of_klass model_klass, params
        end

        protected

        def comparison_filter field, comparison_operator_modifier, value
          where "#{field}_#{comparison_operator_modifier}".to_sym => value
        end

        def fetch_ex url
          json = get_json url
          clear
          items = []
          if json


            items = json[plural_resource_name].map do |instance_params|
              new instance_params
            end
            items = attach_content_to_items items, json['content']
          end
          {:items => items, :json => json}
        end

        def attach_content_to_items items, content_json_array
          if content_json_array.present?
            items.each do |item|
              item.content_ids.each do |content_id|
                content_json = content_json_array.find { |ct| ct['id'] == content_id }
                if content_json
                  item.send :append_content, new_instance_of_klass(Conversocial::Resources::Models::Content, content_json)
                end
              end
            end
          end
          items
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
          full_path = absolute_path path

          response =  @cache.get_or_set full_path, :get => ->(){
            client.send :log, self, full_path
            https_basic_auth_get client.key, client.secret, full_path
          }, :if => ->( response ){
            response.code.to_i >= 200 && response.code.to_i < 300
          }

          if 429 == response.code.to_i
            raise Conversocial::Resources::Exceptions::RateLimitExceeded.new response.code, nil, response.body
          end

          json = JSON.parse response.body
          if response.kind_of? Net::HTTPSuccess
            json
          else
            if 404 == response.code.to_i
              if json['message'] == "No such #{resource_name}"
                #puts "returning nil here"
                return nil
              end
            end

            #some unknown error happened so raise standard exception
            raise Conversocial::Resources::Exceptions::Base.new response.code, response.message, json['message']
          end
        end

        def new_instance_of_klass klass, params
          new_instance = klass.new
          new_instance.send :assign_client, client
          new_instance.send :assign_query_engine, self
          new_instance.assign_attributes params
          new_instance
        end

      end
    end
  end
end