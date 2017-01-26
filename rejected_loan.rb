require 'csv'
require 'pg'

class RejectedLoan
  attr_reader :id
  attr_accessor :amount, :application_date, :loan_title, :risk_score, :debt_to_income,
    :zip_code, :state, :employment_length

  def initialize(options)
    @id = options['id']
    @amount = options['amount']
    @application_date = options['application_date']
    @loan_title = options['loan_title']
    @risk_score = options['risk_score']
    @debt_to_income = options['debt_to_income']
    @zip_code = options['zip_code']
    @state = options['state']
    @employment_length = options['employment_length']
  end

  def save
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    conn.exec_params("INSERT INTO #{table_name} (amount, application_date, loan_title, risk_score,
    debt_to_income, zip_code, state, employment_length) VALUES ($1, $2, $3, $4, $5, $6, $7, $8);",
    [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length])
    conn.close
  end

  def self.get_search_input
    puts "Please enter a columnn name from the list below to search: "
    display_db_fields
    field_name = gets.chomp.downcase
    puts "Enter a value from the list below to search: "
    get_field_values(field_name)
    search_value = gets.chomp
    search_database(field_name, search_value)
  end

  def self.search_database(field_name, search_value)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    results = conn.exec_params("SELECT * FROM #{table_name} WHERE #{field_name} = $1;", [search_value])
    output_results(results)
  end

  def self.get_sort_input
    puts "Please enter a column name from the list below for a sorted table: "
    display_db_fields
    sort_field = gets.chomp.downcase
    puts "Please enter ASC or DESC sort order: "
    sort_order = gets.chomp.upcase
    sort_database(sort_field, sort_order)
  end

  def self.sort_database(sort_field, sort_order)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    sort_field = conn.quote_ident(sort_field)
    results = conn.exec_params("SELECT * FROM #{table_name} ORDER BY #{sort_field} #{sort_order};")
    conn.close
    output_results(results)
  end

  def self.get_delete_input
    puts "Please enter a columnn name to filter and locate record to delete: "
    display_db_fields
    field_name = gets.chomp.downcase
    puts "Enter a value from the list below to search: "
    get_field_values(field_name)
    search_value = gets.chomp
    search_database(field_name, search_value)
    puts "Enter the record id you would like to delete: "
    id_to_delete = gets.chomp.to_i
    delete_record(id_to_delete, field_name, search_value)
  end

  def self.delete_record(record_id, field_name, search_value)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    delete_results = conn.exec_params("DELETE FROM #{table_name} WHERE id = $1;", [record_id])
    results = search_database(field_name, search_value)
    conn.close
    output_results(results)
    puts "Record #{record_id} has been deleted."
  end

  def self.get_add_input
    options = {}
    puts "Please enter the details of the rejected loan."
    puts "Amount of the rejected loan: (00.00)"
    amount = gets.chomp.to_f
    puts "Application date: (YYYY-MM_DD)"
    application_date = gets.chomp
    puts "Loan title: (text)"
    loan_title = gets.chomp
    puts "Risk score: (0)"
    risk_score = gets.chomp.to_i
    puts "Debt to income: (0.0)"
    debt_to_income = gets.chomp.to_f
    puts "Zip code: (text)"
    zip_code = gets.chomp
    puts "State: (ST)"
    state = gets.chomp.upcase
    puts "Employment length: (text)"
    employment_length = gets.chomp

    options = {'amount' => amount, 'application_date' => application_date, 'loan_title' => loan_title, 'risk_score' => risk_score,
    'debt_to_income' => debt_to_income, 'zip_code' => zip_code, 'state' => state, 'employment_length' => employment_length}

    rejected_loan = RejectedLoan.new(options)
    rejected_loan.save
    field_name = 'application_date'
    search_database("#{field_name}", rejected_loan.application_date)

  end

  def self.get_field_values(field_name)
    db_values = []
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    field_name = conn.quote_ident(field_name)
    db_values = conn.exec("SELECT DISTINCT #{field_name} FROM #{table_name};")
    conn.close
    values = db_values.values.join(" ")
    p values.gsub ' ', " | "
  end

  def self.display_db_fields
    db_fields = []
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    db_fields = conn.exec("SELECT * FROM #{table_name} WHERE id=0;")
    conn.close
    columns = db_fields.fields.join(" ")
    p columns.gsub ' ', " | "
  end

  def self.output_results(results)
    format = "%-10s\t%-15s\t%-10s\t%-20s\t%-10s\t%-20s\t%-10s\n"
    printf(format, "ID", "Amount", "Debt to Income", "Loan Title", "Risk Score", "Employment Length", "State\n")
    results.each do |result|
      printf(format, "#{result['id']}", "$""#{result['amount']}", "#{result['debt_to_income']}",
      "#{result['loan_title']}", "#{result['risk_score']}", "#{result['employment_length']}", "#{result['state']}")
    end
  end

  def self.create_table
    conn = PG.connect(dbname: 'search_engine_oop')

    begin
      result = conn.exec('CREATE TABLE IF NOT EXISTS reject_stats_oop (id serial primary key, amount numeric,
      application_date date, loan_title varchar, risk_score integer, debt_to_income numeric, zip_code varchar,
      state varchar, employment_length varchar);')
    rescue PG::DuplicateTable => e
      puts "That table already exists.."
    end
    conn.close
  end

  def self.seed_database()
    seed_file_path = '/Users/Joe/Documents/TIY/Week3/search_engine_oop/data/q3_reject_stats.csv'
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

      options = {'amount' => amount, 'application_date' => application_date, 'loan_title' => loan_title, 'risk_score' => risk_score,
      'debt_to_income' => debt_to_income, 'zip_code' => zip_code, 'state' => state, 'employment_length' => employment_length}

      rejected_loan = RejectedLoan.new(options)
      rejected_loan.save
      options = {}
    end
  end
end
