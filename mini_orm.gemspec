# frozen_string_literal: true

require_relative "lib/mini_orm/version"

Gem::Specification.new do |spec|
  # name
  spec.name        = "mini_orm"
  # version
  spec.version     = MiniORM::VERSION
  # summary
  spec.summary     = "Tiny ActiveRecord-style ORM for SQLite"
  # description
  spec.description = "Ultra-light ORM with dynamic attributes, .all, .find, .where, .save, .delete"
  # authors
  spec.authors     = ["Your Name"]
  # email
  spec.email       = ["you@example.com"]
  # homepage
  spec.homepage    = "https://github.com/yourname/mini_orm"
  # license
  spec.license     = "MIT"

  # files
  spec.files = Dir["lib/**/*", "README.md", "LICENSE", "examples/**/*"]
  # require paths
  spec.require_paths = ["lib"]

  # runtime deps
  spec.add_dependency "sqlite3", "~> 1.6"

  # Ruby version
  spec.required_ruby_version = ">= 3.0"
end
