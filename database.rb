#thin methods, Table does the work
require_relative 'table'

class Database

  def exists?
      db_exists_sql = "SELECT 1 from pg_database WHERE datname = $1;"
      db_exist_result = @connection.exec_params(db_exists_sql,[@name])
      if db_exist_result.num_tuples == 1
        true
      else
        false
      end
  end

  def create_tables
    @tables.each { |table| table.create unless table.exists? }
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

  def records_exist?
    @tables.each { |table| table.records?}
  end
end
