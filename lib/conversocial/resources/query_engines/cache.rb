module Conversocial
  module Resources
    module QueryEngines
      class Cache
        attr_reader :expiry

        def initialize expiry=60*60
          @cache = {}
          @expiry = expiry.to_i
        end

        def get_or_set key, options
          result = get key
          if result.nil?
            result = options[:get].call
            if options[:if].call result
              set key, result
            end
          end
          result
        end

        def set key, value
          @cache[key.to_s] = {:value => value, :timestamp => Time.now}
        end

        def delete key
          @cache.delete key.to_s
        end
        
        def get key
          if @cache[key.to_s]
            if (Time.now - @cache[key.to_s][:timestamp]) < expiry
              @cache[key.to_s][:value]
            else
              delete key
              nil
            end
          end
        end
      end
    end
  end
end