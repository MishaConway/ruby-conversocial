# Conversocial

Ruby gem that wraps the conversocial api in an ORM pattern

## Installation

Add this line to your application's Gemfile:

    gem 'conversocial'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conversocial

## Usage

Disclaimer: I am still working on in depth documentation for this gem. In the meantime, I tried to provide some quick example snippets here.

Initialize the client with your key and secret

    client = Conversocial::Client.new :key => '...', :secret => '...'

And then fetch some data

    client.conversations.limit(3).fetch #note that limit is only supported on conversations
    client.conversations.where( :status => 'unread' ).fetch
    client.tags.fetch
    client.users.fetch
    client.accounts.fetch
    client.channels.fetch
    client.reports.fetch

To find a resource by id

    client.accounts.find 13954
    client.tags.find 98999

To paginate through all of a certain resource do

    client.tags.each_page{ |tags| .... }
    client.conversations( :status => 'unread' ).each_page{ |conversations| ... }

Items not yet supported, but that will be in a soon future version

    -saving of reports
    -the keyvalue resource

## Contributing

1. Fork it ( https://github.com/[my-github-username]/conversocial/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
