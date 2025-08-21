# mini_orm

Tiny ActiveRecord-style ORM for SQLite.

## Quickstart

```ruby
# install: bundle install
# run example: ruby examples/usage.rb
```

## Usage

```ruby
require "mini_orm"

MiniORM.connect("dev.sqlite3")

class User < MiniORM::Base; end

# create table once (for demo)
MiniORM.connection.execute <<~SQL
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT
  );
SQL

u = User.new(name: "Ada", email: "ada@example.com")
u.save

puts User.all.map { |x| [x.id, x.name] }.inspect
puts User.find(u.id).email
puts User.where(name: "Ada").size

u.name = "Ada Lovelace"
u.save

u.delete
```

## Notes
- SQLite backend via `sqlite3` gem
- Dynamic attribute methods from table columns
- API: `.all`, `.find(id)`, `.where(...)`, `#save`, `#delete`
