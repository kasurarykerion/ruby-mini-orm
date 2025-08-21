# ruby-mini-orm
Tiny ActiveRecord-style ORM for SQLite. Dynamic attributes + .all, .find, .where, .save, .delete. Zero magic, ultra-light, Ruby.

A minimal, human-sized ORM for Ruby:

Dynamic attribute methods inferred from table columns
Simple API: .all, .find(id), .where(...), #save, #delete
SQLite backend via sqlite3
No Rails required, no heavy abstractions
Features

Dynamic attributes from PRAGMA table_info
Table name inferred from class name (User -> users)
Insert/update via #save, delete via #delete
Where supports Hash or SQL fragment with params
Quickstart

Ruby 3.0+
gem install sqlite3
ruby examples/usage.rb
Usage

```ruby
require "mini_orm"

MiniORM.connect("dev.sqlite3")

class User < MiniORM::Base; end

MiniORM.connection.execute <<~SQL
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT
  );
SQL

u = User.new(name: "Ada", email: "ada@example.com")
u.save

User.all
User.find(u.id)
User.where(name: "Ada")

u.name = "Ada Lovelace"
u.save

u.delete
Why

Learnable in minutes
Great for scripts, prototypes, and teaching metaprogramming
Stays close to SQLite, avoids complex DSLs
Roadmap

Type adapters (date/time/boolean)
Basic validations
Associations (has_many/belongs_to)
```
