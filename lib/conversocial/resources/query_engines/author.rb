module Conversocial
  module Resources
    class Author
      def self.fields
        %w{id url platform platform_id screen_name real_name location website description profile_picture profile_link}
      end
      fields.each{ |f| attr_accessor f }


      def self.find key, secret, author_id, options={}
        options[:fields] ||= fields.join(',')

        begin
        json = ::JSON.parse RestClient.get add_query_params("https://ajv9sa7o3:plz65pmd2gvutqn3c@api.conversocial.com/v1.1/authors/#{author_id}", options)
        rescue Exception => e
          e
        end
      end

      def self.add_query_params(url, params_to_add)
        uri = URI url
        params = (params_to_add || {}).merge URI.decode_www_form(uri.query.to_s).to_h
        return url if params.blank?
        uri.query = URI.encode_www_form(params)
        uri.to_s
      end

    end
  end
end