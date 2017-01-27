class Row
  def initialize(options)
    @fields = options[:fields]
    @values = options[:values]
  end

  def insert
    result = conn.exec_params(
      "INSERT INTO #{table_name} (amount, application_date, loan_title, risk_score,
      debt_to_income, zip_code, state, employment_length) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id;",
      [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length])
    @id = result[0]['id']
  end

  def update
    conn.exec_params(
      "UPDATE #{table_name} SET amount = $1, application_date = $2, loan_title = $3, risk_score = $4,
      debt_to_income = $5, zip_code = $6, state = $7, employment_length = $8 WHERE id = $9;",
      [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length, @id])
  end

  def delete
    delete_sql = ("DELETE FROM #{table_name} WHERE id = $1;", [record_id])
    delete_results = conn.exec_params(delete_sql)
  end

  def find
    find_sql = ("SELECT * FROM #{table_name} WHERE id = $1 LIMIT 1;", [id])
    result = conn.exec_params("SELECT * FROM #{table_name} WHERE id = $1 LIMIT 1;", [id])
    return nil unless result.num_tuples == 1
    RejectedLoan.new(result[0])
  end
