queued-ruby
===

[Queued](http://github.com/scttnlsn/queued) client for Ruby

Example
---

```ruby
require 'queued-ruby'

client = Queued::Client.new('http://localhost:5353', auth: 'secret')
queue = client.queue('testing')
```

Producer:

```ruby
item = queue.enqueue(foo: 'bar')
```

Consumer:

```ruby
item = queue.dequeue(timeout: 10, wait: 30)
if item
  p item.value
  item.complete
end
```

Install
---

    gem install queued-ruby