# require lib
require_relative "../lib/mini_orm"

# connect db
MiniORM.connect("dev.sqlite3")

# schema (demo only)
MiniORM.connection.execute <<~SQL
  CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    email TEXT
  );
SQL

# model
class User < MiniORM::Base; end

# create
u = User.new(name: "Ada", email: "ada@example.com")
u.save

# read
puts User.all.map { |x| { id: x.id, name: x.name } }
puts User.find(u.id).email
puts User.where(name: "Ada").size

# update
u.name = "Ada Lovelace"
u.save

# delete
u.delete
