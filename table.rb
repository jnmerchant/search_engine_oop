require_relative 'row'

class Table
  def initialize (options)
    @name = options[:name]
    @rows = options[:rows]
    @database.connection
    @field_names = []
  end

  def exits?

  end

  def create(fields)
    @field_names = fields.map { |name, data_type| name }
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

  def insert_row
    #looks to Row class
  end

  def update_row
    #looks to Row class
  end

  def delete_row
    #looks to Row class
  end

  def find_by
    #looks to Row class
  end

  # TODO: refactor in to Table
  def records_exist?
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    records = conn.exec_params("SELECT COUNT(*) FROM #{table_name};")
    conn.close
    row_count = records.getvalue 0, 0
    row_count.to_i > 0
  end

end
