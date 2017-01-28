require_relative 'row'

class Table
  def initialize (options)
    @name = options['name']
    @rows = options['rows']
    @database.connection
  end

  def exists?
    table_name = conn.quote_ident(@name)
    schema_name = conn.quote_ident('public')

    table_exists_sql = "SELECT EXISTS (
      SELECT 1 FROM pg_tables
      WHERE schemaname = #{schema_name}
      AND tablename = #{table_name});"
    result = conn.exec_params(table_exists_sql)
    conn.close
    result[0] ? true : false
  end

  def create(fields)
    merge_fields_and_datatypes = fields.map { |name, data_type| name + ' ' + data_type + ', ' }
    fields_to_query = merge_fields_and_datatypes.join
    create_table_query = ("CREATE TABLE IF NOT EXISTS '#{@name}' ('#{fields_to_query}');")
    result = conn.exec_params(create_table_query)
  end

  def drop
    drop_table_query = ("DROP TABLE IF EXISTS '#{@name}';")
  end

  def seed(seed_file_path)
    options = {}

    CSV.foreach(seed_file_path, {:headers => true }) do |row|
      amount = row[0].to_f
      application_date = row[1]
      loan_title = row[2]
      risk_score = row[3].to_i
      debt_to_income = /[\d+\.]/.match(row[4])
      zip_code = row[5]
      state = row[6]
      employment_length = row[7]

      values = [amount, application_date, loan_title, risk_score, debt_to_income, zip_code,
        state, employment_length]
      options = Hash[@fields.zip(values.map {|value| value.include?(',') ? (value.split /, /) : value})]
      rejected_loan = RejectedLoan.new(options)
      rejected_loan.save
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

  def find_by
    #looks to Row class
  end

  # TODO: refactor in to Table
  def records_exist?
    conn = PG.connect(dbname: database.name)
    table_name = conn.quote_ident(@table_name)
    records_exist_sql = "SELECT COUNT(*) FROM #{table_name};"
    records = conn.exec_params(records_exist_sql)
    conn.close
    row_count = records.getvalue 0, 0
    row_count.to_i > 0
  end
end
