# HorizonClient

Client to use with Horizon REST xml API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'horizon_client'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install horizon_client
```

## Usage

```ruby
client = HorizonClient.new
client.logger = Logger.new(STDOUT)

# incoming xml:
# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <resource>
#   <entity>
#     <name>Jack</name>
#     <foo><bar>Jill</bar></foo>
#   </entity>
#   <collection>
#     <row>
#     </row>
#     <row>
#     </row>
#   </collection>
#   <group>
#     <link>
#     </link>
#     <link>
#     </link>
#   </group>
# </resource>

# returns and expects HorizonClient::Resource object
resource = client.get('path')
return_resource = client.post('path', resource)

# get entity:
entity = resource.entity

# get result entity after successful upload
result = return_resource.result

# get and set object values
entity['name'] # => 'Jack'
entity['name'] = 'Jane'
entity['foo/bar'] # => 'Jill'
entity['foo/baz'] = 'Joe' # => <foo><bar>Jill</bar><baz>Joe</baz></foo>

# get or set collection with specified name inside entity
col = entity.get_collection('col')
row = col.build # => #<HorizonClient::Entity>
# result:
# <entity>
#   ...
#   <col>
#     <row></row>
#   </col>
# </entity>

# get first level collection.
collection = resource.collection
entity_array = collection.rows # => [ #<HorizonClient::Entity> ]
entity_array.each do |entity|
  entity['foo'] = 'test'
end

# get group with links, it behaves just like collection
group = resource.group

```


### Necessary environment variables

* **HORIZON_REST_URL** e.x. http://user:pass@ip:port/rest. Note the "/rest" part

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
