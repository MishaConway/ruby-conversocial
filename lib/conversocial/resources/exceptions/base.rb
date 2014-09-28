module Conversocial
  module Resources
    module Exceptions
      class Base < ::StandardError

        attr_reader :status_code, :server_message, :application_message
        attr_writer :default_message

        def initialize(status_code = nil, server_message = nil, application_message = nil)
          @status_code = status_code
          @server_message = server_message
          @application_message = application_message
        end

        def to_s
          "\nStatus: #{status_code}\nServer Message: #{server_message}\nApplication Message: #{application_message}"
        end
      end
    end
  end
end