module Conversocial
  module Resources
    module Exceptions
      class Base < ::StandardError
        attr_reader :status_code, :server_message, :application_message

        def initialize(status_code = nil, server_message = nil, application_message = nil)
          @status_code = status_code
          @server_message = server_message
          @application_message = application_message
        end

        def to_s
          lines = []
          lines << "Status: #{status_code}" if status_code.present?
          lines << "Server Message: #{server_message}" if server_message.present?
          lines << "Application Message: #{application_message}" if application_message.present?
          "\n" + lines.join("\n")
        end
      end
    end
  end
end