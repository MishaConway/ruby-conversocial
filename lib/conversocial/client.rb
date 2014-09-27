module Conversocial
  class Client
    attr_reader :version, :key, :secret


    def initialize options={}
      @key = options[:key] 
      @secret = options[:secret]
      @version = options[:version]
    end

    def accounts
      @accounts ||= Conversocial::Resources::QueryEngines::Account.new self
    end

    def authors
      @authors ||= Conversocial::Resources::QueryEngines::Author.new self
    end

    def channels
      @channels ||= Conversocial::Resources::QueryEngines::Channel.new self
    end

    def keyvalues
      @keyvalues ||= Conversocial::Resources::QueryEngines::Keyvalue.new self
    end

    def reports
      @reports ||= Conversocial::Resources::QueryEngines::Report.new self
    end

    def tags
      @tags ||= Conversocial::Resources::QueryEngines::Tag.new self
    end

    def users
      @users ||= Conversocial::Resources::QueryEngines::User.new self
    end

    def conversations
      @conversations ||= Conversocial::Resources::QueryEngines::Conversation.new self
    end
  end
end