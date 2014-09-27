module Conversocial
  class Client
    attr_reader :version, :key, :secret


    def initialize options={}
      @key = options[:key]
      @secret = options[:secret]
      @version = options[:version]
    end

    def accounts
      (@accounts ||= Conversocial::Resources::QueryEngines::Account.new self).clear
    end

    def authors
      (@authors ||= Conversocial::Resources::QueryEngines::Author.new self).clear
    end

    def channels
      (@channels ||= Conversocial::Resources::QueryEngines::Channel.new self).clear
    end

    def keyvalues
      (@keyvalues ||= Conversocial::Resources::QueryEngines::Keyvalue.new self).clear
    end

    def reports
      (@reports ||= Conversocial::Resources::QueryEngines::Report.new self).clear
    end

    def tags
      (@tags ||= Conversocial::Resources::QueryEngines::Tag.new self).clear
    end

    def users
      (@users ||= Conversocial::Resources::QueryEngines::User.new self).clear
    end

    def conversations
      (@conversations ||= Conversocial::Resources::QueryEngines::Conversation.new self).clear
    end
  end
end