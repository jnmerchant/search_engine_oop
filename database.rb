#thin methods, Table does the work
require_relative 'table'

class Database
  def initialize(options)
    @name = options[:name]
    @tables = options[:tables]
    @connection = options[:connection]
  end

  def create_tables
    @tables.each { |table| table.create }
  end

  def drop_tables
    @tables.each { |table| table.drop }
  end

  def seed
    @tables.each { |table| table.seed }
  end

  def exists?
    @tables.each { |table| table.exists?}
  end
end
