module Conversocial
  class Client
    attr_reader :version


    def initialize options={}
      @key = options[:key]
      @secret = options[:secret]
      @version = options[:version]
    end

    def accounts

    end

    def find_author author_id, options={}
      Conversocial::Resources::Author.find @key, @secret, author_id, options
    end

    def channels

    end

    def keyvalues

    end

    def reports

    end

    def tags

    end

    def users

    end



    def conversations
      Conversocial::Resources::QueryEngines::Conversation.new @key, @secret
    end
  end
end