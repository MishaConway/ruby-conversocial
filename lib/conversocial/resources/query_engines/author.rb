module Conversocial
  module Resources
    module QueryEngines
      class Author < Base
        undef_method :all
        undef_method :limit

        def initialize client
          super client
        end

        protected

        def model_klass
          Conversocial::Resources::Models::Author
        end

      end
    end
  end
end