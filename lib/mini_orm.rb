# frozen_string_literal: true

# requires
require "sqlite3"

# version
require_relative "mini_orm/version"
# base
require_relative "mini_orm/base"

# namespace
module MiniORM
  class << self
    # connection holder
    attr_accessor :connection

    # connect(db_path)
    def connect(db_path)
      db = SQLite3::Database.new(db_path)
      db.results_as_hash = true
      db.type_translation = true
      self.connection = db
    end
  end
end
