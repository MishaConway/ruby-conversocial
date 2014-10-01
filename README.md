# Conversocial

Ruby gem that wraps the conversocial api in an ORM pattern

## Installation

Add this line to your application's Gemfile:

    gem 'conversocial'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install conversocial

## Initialize

Initialize the client with your key and secret

    client = Conversocial::Client.new :key => '...', :secret => '...'

## Resources

Currently, this gem wraps most of the resources exposed by the Conversocial API. You can access these resources via the following query engines on the client object.

    client.accounts
    client.authors
    client.channels
    client.conversations
    client.reports
    client.tags
    client.users

Each of these returns a QueryEngine object for that respective resource with a variety of fetch/find/filter methods that can be chained together to programmatically build richer queries. When a query is executed, it will return a model or an array of models. (See section below for more information on models)


## Finding Items
All of the query engines have a find method which takes an id. Some examples below:
  
    client.accounts.find 13954
       => #<Conversocial::Resources::Models::Account(url: https://api.conversocial.com/v1.1/accounts/13954, reports: https://api.conversocial.com/v1.1/reports?account=13954, id: 13954, channels: ["#<Channel(id: 64079)>", "#<Channel(id: 64091)>", "#<Channel(id: 64080)>", "#<Channel(id: 64082)>"], description: My Test Account, package: Enterprise, created_date: 2013-09-24 17:16:06 -0700, name: My Test Account)>

    client.tags.find 25494
       => #<Conversocial::Resources::Models::Tag(id: 25494, name: Test Tag, url: https://api.conversocial.com/v1.1/tags/25494, is_active: true)>



## Fetching Data
With the exception of authors, all query engines support a fetch method that can be used to return multiple items

    client.tags.fetch
       => [#<Conversocial::Resources::Models::Tag(id: 25494, name: Tag1, url: https://api.conversocial.com/v1.1/tags/25494, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25495, name: Tag2, url: https://api.conversocial.com/v1.1/tags/25495, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25496, name: Tag3, url: https://api.conversocial.com/v1.1/tags/25496, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25497, name: Tag4, url: https://api.conversocial.com/v1.1/tags/25497, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25498, name: Tag5 url: https://api.conversocial.com/v1.1/tags/25498, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25499, name: Conversational, url: https://api.conversocial.com/v1.1/tags/25499, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25500, name: Tag6, url: https://api.conversocial.com/v1.1/tags/25500, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25501, name: Tag7, url: https://api.conversocial.com/v1.1/tags/25501, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25502, name: Tag8, url: https://api.conversocial.com/v1.1/tags/25502, is_active: true)>, #<Conversocial::Resources::Models::Tag(id: 25877, name: Tag9, url: https://api.conversocial.com/v1.1/tags/25877, is_active: true)>]

## Filtering
It is possible to filter your find and fetch queries.

    client.conversations.where( :status => 'unread' ).fetch 
    client.conversations.where( :status => ['unread', 'archived'] ).fetch

It is possible to chain filters

    client.conversations.where(:status => 'archived').where(:assigned_to => user.id ).fetch

## Comparison Filters

    #get all tags with id larger than 30000
    client.tags.greater_than(:id, 30000).fetch

    #get all conversations where oldest sort date is greater than or equal to today
    client.conversations.greater_than_or_equal_to(:oldest_sort_date, Date.today ).fetch 

    #get all conversations where oldest sort date is greater than today
    client.conversations.greater_than(:oldest_sort_date, Date.today ).fetch

    #get all conversations where oldest sort date is lesser than or equal to today
    client.conversations.lesser_than_or_equal_to(:oldest_sort_date, Date.today ).fetch

    #get all conversations where oldest sort date is lesser than today
    client.conversations.lesser_than(:oldest_sort_date, Date.today ).fetch

    #get all users where first name is nil
    client.users.is_nil(:first_name).fetch

    #get all users where first name is not nil
    client.users.is_not_nil(:first_name).fetch

## Sorting
It is possible to sort your queries

    client.conversations.sort(:oldest_sort_date).fetch 

## Limiting
The only resources that can be limited are conversations.

    client.conversations.limit(4).fetch    #only return up to four conversations

## Selecting
By default, all fields are selected when you query for resources. However, it is possible to select only a few fields and reduce your api usage.

    conversations.select( 'id', 'status' ).fetch.first
      => #<Conversocial::Resources::Models::Conversation(id: 5399e4ff0e4b3d76a56e5533, url: not_yet_loaded, status: archived, is_priority: not_yet_loaded, contains_private: not_yet_loaded, tags: not_yet_loaded, author: not_yet_loaded, channels: not_yet_loaded, assigned_to: not_yet_loaded, content_ids: not_yet_loaded, handling_times: not_yet_loaded)>

In the example above, you can see that only the id and status are returned. If for some reason, you decide that you need every field you can call refresh on the returned model. You may be wondering what happens if you attempt to invoke an unloaded field. In this case, the model will automatically refresh itself.

    tag = client.tags.where(:fields => 'id').first
       => #<Conversocial::Resources::Models::Tag(id: 25494, name: not_yet_loaded, url: https://api.conversocial.com/v1.1/tags/25494, is_active: not_yet_loaded)>
    tag.refresh
       => #<Conversocial::Resources::Models::Tag(id: 25494, name: Test Tag, url: https://api.conversocial.com/v1.1/tags/25494, is_active: true)>




## Pagination
Using the pagination api  is the best way to enumerate through an entire dataset. 

    client.tags.each_page do |tags|
      tags.each do |tag|
        puts "processing #{tag.name}"
      end
    end

To get all the conversations for today

    client.conversations.greater_than_or_equal_to(:oldest_sort_date, Date.today ).limit(50).each_page do |conversations|
      conversations.each do |conversation|
        puts "conversation #{conversation.id}"
        conversation.contents.each do |content|
          puts "#{content.author.try(:real_name)}: #{content.text}"
        end
        puts "\n"
      end
    end


## Future Developments
Items not yet supported, but that will be in a soon future version

-saving of reports

-the keyvalue resource

-more documentation

## Contributing

1. Fork it ( https://github.com/[my-github-username]/conversocial/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request