require_relative 'row'
require_relative 'structures'
require 'csv'

class MissingTableStructureDefinition < StandardError
end

class MissingTableName < StandardError
end

class Table
  attr_reader :name, :rows, :record_count

  def initialize (table_options)
    @name = table_options['name']
    @rows = table_options['rows']
    @record_count = ''
    @connection = table_options['connection']
  end

  def exists?
    table_name = @connection.quote_ident(@name)
    schema_name = @connection.quote_ident('pg_catalog') # Hard Coded schema_name
    table_exists_sql = "SELECT EXISTS (
      SELECT 1 FROM pg_tables
      WHERE schemaname = '#{schema_name}' AND tablename = '#{table_name}');"
    result = @connection.exec_params(table_exists_sql)
    result[0]['exists'] == 'f' ? false : true
  end

  def create
    fields = get_table_fields
    merge_fields_and_datatypes = fields.map { |name, data_type| name + ' ' + data_type + ', ' }
    fields_to_query = merge_fields_and_datatypes.join.chop.chop
    create_table_query = ("CREATE TABLE IF NOT EXISTS #{@name} (#{fields_to_query});")
    result = @connection.exec_params(create_table_query)
  end

  def drop
    drop_table_query = ("DROP TABLE IF EXISTS '#{@name}';")
  end

  def seed
    seed_file_path = get_file_paths(@name)
    options = {}
    CSV.foreach(seed_file_path, {:headers => true }) do |row|
      values = process_csv_row(@name, row)
      fields = get_table_fields.delete_if { |key, value| key == 'id' }
      options = Hash[fields.zip(values.map {|value| value.include?(',') ? (value.split /, /) : value})]
      row_object = Row.new(options, @name)
      row_object.insert(@connection)
      options = {}
    end
  end

  def insert_row
    @row.each { |row| row.insert }
  end

  def update_row
    @row.each { |row| row.update }
  end

  def delete_row
    @row.each { |row| row.delete }
  end

  def find_by_id(id)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    result = conn.exec_params("SELECT * FROM #{table_name} WHERE id = $1 LIMIT 1;", [id])
    return nil unless result.num_tuples == 1
    RejectedLoan.new(result[0])
  end

  def records
    table_name = @connection.quote_ident(@name)
    records_exist_sql = "SELECT COUNT(*) FROM #{table_name};"
    records_result = @connection.exec_params(records_exist_sql)
    row_count = records_result.getvalue 0, 0
    @record_count = row_count.to_i
  end

  def search_database(field_name, search_value)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    results = conn.exec_params("SELECT * FROM #{table_name} WHERE #{field_name} = $1;", [search_value])
    output_results(results) # TODO: return array of objects, don't print them, do print elsewhere
  end

  def sort_database(sort_field, sort_order)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    sort_field = conn.quote_ident(sort_field)
    results = conn.exec_params("SELECT * FROM #{table_name} ORDER BY #{sort_field} #{sort_order};")
    conn.close
    output_results(results) # TODO: return array of objects, don't print them, do print elsewhere
  end

  def get_table_fields
    get_table_structures(@name)
  end
end
