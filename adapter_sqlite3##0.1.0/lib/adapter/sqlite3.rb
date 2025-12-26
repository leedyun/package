require "adapter"
require "sqlite3"

module Adapter
  module Sqlite3
    def key?(key, options = nil)
      @exists.execute!(key).first.first.to_i == 1
    end
    
    def read(key, options = nil)
      do_setup
      rows = @select.execute!(key)
      rows.empty? ? nil : rows.first.first
    end

    def write(key, attributes, options = nil)
      do_setup
      @replace.execute!(key, attributes)
      attributes
    end

    def delete(key, options = nil)
      do_setup
      @delete.execute!(key)
    end

    def clear(options = nil)
      do_setup
      @clear.execute!
    end
    
    private
    def do_setup
      return if @sqlite_setup_done
      table = 'adapter'
      client.busy_timeout(options[:busy_timeout] || 1000)
      client.execute("create table if not exists #{table} (k blob not null primary key, v blob)")
      @statements =
        [@exists  = client.prepare("select exists(select 1 from #{table} where k = ?)"),
         @select  = client.prepare("select v from #{table} where k = ?"),
         @replace = client.prepare("replace into #{table} values (?, ?)"),
         @delete  = client.prepare("delete from #{table} where k = ?"),
         @clear   = client.prepare("delete from #{table}")]
      @sqlite_setup_done=true
    end
  end
end

Adapter.define(:sqlite3, Adapter::Sqlite3)
