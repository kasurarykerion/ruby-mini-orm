# frozen_string_literal: true

# namespace
module MiniORM
  # base class
  class Base
    # table_name accessor
    class << self
      attr_accessor :table_name
    end

    # hook on subclass
    def self.inherited(subclass)
      super
      subclass.table_name = infer_table_name(subclass.name)
      subclass.instance_variable_set(:@columns, nil)
    end

    # connection helper
    def self.connection
      MiniORM.connection
    end

    # columns cache
    def self.columns
      @columns ||= begin
        info = connection.execute("PRAGMA table_info(#{table_name})")
        cols = info.map { |r| r["name"] }
        define_model_accessors(cols)
        cols
      end
    end

    # primary key name
    def self.primary_key
      "id"
    end

    # .all
    def self.all
      rows = connection.execute("SELECT * FROM #{table_name}")
      rows.map { |row| instantiate(row) }
    end

    # .find(id)
    def self.find(id)
      row = connection.get_first_row("SELECT * FROM #{table_name} WHERE #{primary_key} = ? LIMIT 1", id)
      instantiate(row)
    end

    # .where(hash or sql, *params)
    def self.where(conditions, *params)
      if conditions.is_a?(Hash)
        keys = conditions.keys
        sql = keys.map { |k| "#{k} = ?" }.join(" AND ")
        params = keys.map { |k| conditions[k] }
        rows = connection.execute("SELECT * FROM #{table_name} WHERE #{sql}", params)
      else
        rows = connection.execute("SELECT * FROM #{table_name} WHERE #{conditions}", params)
      end
      rows.map { |row| instantiate(row) }
    end

    # instantiate row -> object
    def self.instantiate(row)
      return nil unless row
      obj = new
      obj.send(:load_attributes, row)
      obj
    end

    # infer table from class
    def self.infer_table_name(class_name)
      snake = class_name
                .gsub(/::/, "_")
                .gsub(/([A-Z]+)([A-Z][a-z])/, '\\1_\\2')
                .gsub(/([a-z\d])([A-Z])/, '\\1_\\2')
                .tr("-", "_")
                .downcase
      snake.end_with?('s') ? snake : "#{snake}s"
    end

    # dynamic accessors per column
    def self.define_model_accessors(cols)
      cols.each do |col|
        define_method(col) { @attributes[col.to_s] }
        define_method("#{col}=") { |val| @attributes[col.to_s] = val }
      end
    end

    # init with attrs
    def initialize(attrs = {})
      @attributes = {}
      self.class.columns
      attrs.each { |k, v| public_send("#{k}=", v) if respond_to?("#{k}=") }
    end

    # save (insert/update)
    def save
      pk = self.class.primary_key
      if public_send(pk)
        update_record
      else
        insert_record
      end
      self
    end

    # delete
    def delete
      pk = self.class.primary_key
      return self unless public_send(pk)
      self.class.connection.execute("DELETE FROM #{self.class.table_name} WHERE #{pk} = ?", public_send(pk))
      self
    end

    private

    # load from row
    def load_attributes(row)
      @attributes ||= {}
      row.each { |k, v| @attributes[k.to_s] = v if k.is_a?(String) || k.is_a?(Symbol) }
      self
    end

    # insert path
    def insert_record
      pk = self.class.primary_key
      cols = self.class.columns.reject { |c| c == pk }
      vals = cols.map { |c| public_send(c) }
      placeholders = (['?'] * cols.size).join(', ')
      sql = "INSERT INTO #{self.class.table_name} (#{cols.join(', ')}) VALUES (#{placeholders})"
      self.class.connection.execute(sql, vals)
      new_id = self.class.connection.last_insert_row_id
      public_send("#{pk}=", new_id) if respond_to?("#{pk}=")
    end

    # update path
    def update_record
      pk = self.class.primary_key
      cols = self.class.columns.reject { |c| c == pk }
      sets = cols.map { |c| "#{c} = ?" }.join(', ')
      vals = cols.map { |c| public_send(c) }
      vals << public_send(pk)
      sql = "UPDATE #{self.class.table_name} SET #{sets} WHERE #{pk} = ?"
      self.class.connection.execute(sql, vals)
    end
  end
end
