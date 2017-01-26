require 'csv'
require 'pg'

class RejectedLoan
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
    conn.exec_params("INSERT INTO reject_stats_oop (amount, application_date, loan_title, risk_score,
    debt_to_income, zip_code, state, employment_length) VALUES ($1, $2, $3, $4, $5, $6, $7, $8);",
    [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length])
    conn.close
  end

  def self.get_search_input
    conn = PG.connect(dbname: 'search_engine_oop')
    puts "Please enter a column from the list below to search: "
    display_db_fields
    field_name = gets.chomp.downcase
    puts "Enter a value from the list below to search: "
    get_field_values(field_name)
    search_value = gets.chomp
    search_database(field_name, search_value)
    conn.close
  end

  def self.search_database(field_name, search_value)
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    results = conn.exec("SELECT * FROM #{table_name} WHERE #{field_name} = '#{search_value}';")
    output_results(results)
  end

  def self.get_field_values(field_name)
    db_values = []
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    field_name = conn.quote_ident(field_name)
    db_values = conn.exec("SELECT DISTINCT #{field_name} FROM #{table_name};")
    values = db_values.values.join(" ")
    p values.gsub ' ', " | "
  end

  def self.display_db_fields
    db_fields = []
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    db_fields = conn.exec("SELECT * FROM #{table_name} WHERE id=0;")
    columns = db_fields.fields.join(" ")
    p columns.gsub ' ', " | "
  end

  def self.output_results(results)
    format = "%-10s\t%-15s\t%-10s\t%-20s\t%-10s\t%-20s\t%-10s\n"
    printf(format, "ID", "Amount", "Debt to Income", "Loan Title", "Risk Score", "Employment Length", "State\n")
    results.each do |result|
      printf(format, "#{result['id']}", "$""#{result['amount']}", "#{result['debt_to_income']}", "#{result['loan_title']}", "#{result['risk_score']}", "#{result['employment_length']}", "#{result['state']}")
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
