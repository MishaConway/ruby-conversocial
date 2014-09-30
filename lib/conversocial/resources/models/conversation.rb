module Conversocial
  module Resources
    module Models
      class Conversation < Base
        def self.fields
          %w{id
url
status
is_priority
contains_private
tags
author
channels
assigned_to
content_ids
contents
handling_times}.map &:to_sym
        end



        attributize_tags






      end
    end
  end
end