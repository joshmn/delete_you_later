# DeleteYouLater

Deletes/destroys associated records in the background, because destroying a billion records in the foreground just will not work.

## Why

Because you probably have destroy callbacks and those are the devil. 😈🔱

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'delete_you_later'
```

And then execute:

    $ bundle

## Usage

```ruby
class Post < ApplicationRecord
  has_many :posts 
  has_many :likes
  
  destroy_dependents_later :posts
  delete_dependents_later :likes
end
```

## Configuration

Drop into an initializer:

```ruby
DeleteYouLater.configure do |config|
  config.scope = :published # default is not scoped
  config.batch_size = 100_000 # default is 100
end
```

You can change these at runtime:

```ruby
class Post < ApplicationRecord
  has_many :posts
  
  destroy_dependents_later :posts, batch_size: 10, scope: :recent 
end
```

## Contributing

This isn't one-size-fits-all but one-size-fits-joshmn's-clients. It might help you too, if not at least give you inspiration for modeling this in your application. I've used this for billions of records with success. Don't ask about my failures.
 
Bug reports and pull requests are kindly welcomed on GitHub at https://github.com/joshmn/delete_you_later

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
