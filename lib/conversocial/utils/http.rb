module Conversocial
  module Utils
    module HTTP
      def https_basic_auth_get basic_auth_name, basic_auth_pass, url
        uri = URI url
        Net::HTTP.start(uri.host, uri.port,
                                   :use_ssl => uri.scheme == 'https',
                                   :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

          request = Net::HTTP::Get.new uri.request_uri
          request.basic_auth basic_auth_name, basic_auth_pass

          http.request request # Net::HTTPResponse object
        end
      end

      def https_basic_auth_post basic_auth_name, basic_auth_pass, url, post_params
        uri = URI url
        Net::HTTP.start(uri.host, uri.port,
                        :use_ssl => uri.scheme == 'https',
                        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

          request = Net::HTTP::Post.new uri.request_uri
          request.basic_auth basic_auth_name, basic_auth_pass
          request.set_form_data post_params

          http.request request # Net::HTTPResponse object
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