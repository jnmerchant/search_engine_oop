#thin methods, Table does the work
require_relative 'table'

class Database
  def create_tables
    @tables.each { |table| table.create }
  end

  def drop_tables
    @tables.each { |table| table.drop }
  end

  def seed_tables
    @tables.each { |table| table.seed }
  end

  def table_exists?
    @tables.each { |table| table.exists?}
  end
end
