DataMapper: Noisy Failures
==========================

[Some have argued](http://www.drmaciver.com/2010/04/datamapper-is-inherently-broken/), that there is fundamental flaw in [DataMapper](http://datamapper.org/): that it "considers booleans to be a superior solution to exceptions." That is, the library does not actively tell you what went wrong when you try to save a record and it fails.

Simple Example
--------------

Consider this simple example:

```ruby
class Person
  include DataMapper::Resource

  property :id,   Serial
  property :name, String, :required => true
end

p = Person.new
p.save # => false
```

Compare this to the behavior you get after requiring `dm-noisy-failures`:

```ruby
require "dm_noisy_failures" # or dm-noisy-failures

p = Person.new
p.save # => DataMapper::SaveFailureError: Person: Name must not be blank
```

There, isn't that better?

Slightly Less Simple Example
----------------------------

The [DataMapper documentation](http://datamapper.org/docs/validations.html) suggests a way to do something similar to the above:

```ruby
def save_record(record)
  if record.save
    puts "Saved record."
  else
    puts "Errors:"
    record.errors.each do |e|
      puts e
    end
  end
end
```

This works just fine for the simple example above. But what if we spice things up a bit?

```ruby
class Person
  has n, :accounts
end

class Account
  include DataMapper::Resource

  belongs_to :person

  property :id,        Serial
  property :person_id, Integer
  property :name,      String, :required => true
end

p = Person.new(:name => "John")
p.accounts << Account.new
save_record(p) # => Errors:
```

What happened? Why don't we see any errors? Because the record passed to `save_record` doesn't *have* any; it's the child record that has the errors.

Now, let's try that again with `dm-noisy-failures` required:

```ruby
require "dm_noisy_failures"

p = Person.new(:name => "John")
p.accounts << Account.new
save_record(p) # => DataMapper::SaveFailureError: Account: Name must not be blank
```

Awesome! Right?

Methods Affected
----------------

This gem aliases the default DataMapper methods `save`, `update`, `create`, and `destroy` with `?` equivalents (`save?`, etc.) which return true or false. The one exception is `create?`, which returns either a resource object or nil.

All four methods are then *replaced* with variations that throw exceptions with informative error messages.

This means that for each operation, there are three options to choose from:

- `save?` (the old default): return true or false
- `save` (the new default): throw exceptions on failure
- `save!` (already part of DataMapper): save without validating
