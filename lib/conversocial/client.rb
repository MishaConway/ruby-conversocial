module Conversocial
  class Client
    attr_reader :version, :key, :secret, :logger

    def initialize options={}
      @key = options[:key]
      @secret = options[:secret]
      @version = options[:version]
      @logger = options[:logger]
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

    #TODO: implement keyvalues support
    #def keyvalues
    #  (@keyvalues ||= Conversocial::Resources::QueryEngines::Keyvalue.new self).clear
    #end

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

protected

    def log engine, message
      if logger
        logger.debug "\033[32m#{[engine.class.name, message].join ' : '}\e[0m"
      end
    end
  end
end