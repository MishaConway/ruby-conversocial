module Conversocial
  class Client
    attr_reader :version, :key, :secret


    def initialize options={}
      @key = options[:key]
      @secret = options[:secret]
      @version = options[:version]
    end

    def accounts

    end

    def authors
      Conversocial::Resources::QueryEngines::Author.new self

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
      Conversocial::Resources::QueryEngines::Conversation.new self
    end
  end
end