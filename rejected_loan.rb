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

  def self.load_file
    conn = PG.connect(dbname: 'search_engine_oop')
    file_path= '/Users/Joe/Documents/TIY/Week3/search_engine_oop/data/q3_reject_stats.csv'

    begin
      result = conn.exec('CREATE TABLE IF NOT EXISTS reject_stats_oop (id serial primary key, amount numeric,
      application_date date, loan_title varchar, risk_score integer, debt_to_income numeric, zip_code varchar,
      state varchar, employment_length varchar);')
    rescue PG::DuplicateTable => e
      puts "That table already exists.."
    end

    seed_database(conn, file_path)
    conn.close
  end

  def self.seed_database(conn, file_path)
    CSV.foreach(file_path, {:headers => true }) do |row|
      amount = row[0].to_f
      application_date = row[1]
      loan_title = row[2]
      risk_score = row[3].to_i
      debt_to_income = /[\d+\.]/.match(row[4])
      zip_code = row[5]
      state = row[6]
      employment_length = row[7]

      conn.exec("INSERT INTO reject_stats (amount, application_date, loan_title, risk_score,
      debt_to_income, zip_code, state, employment_length)
      VALUES ('#{amount}', '#{application_date}', '#{loan_title}', '#{risk_score}',
      '#{debt_to_income}', '#{zip_code}', '#{state}', '#{employment_length}');",
      [amount], )
    end

end
