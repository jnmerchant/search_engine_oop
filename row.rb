class Row
  def initialize(options, name)
    @table_name = name
    @fields_and_values = options
    @fields = get_fields
    @values = get_values
    @param_string = get_params_string
  end

  def get_fields
    field_hash = get_table_structures(@table_name)
    field_hash.delete_if { |key, value| key == 'id' }
    field_keys = field_hash.map { |field, value| field }
    fields = ''
    field_keys.each do |key|
      fields << key + ", "
    end
    fields.chop.chop
  end

  def get_params_string
    number_of_params = @fields_and_values.length
    i = 0
    number_of_params_string = ''
    number_of_params.times do
      i += 1
      number_of_params_string << '$' + i.to_s + ', '
    end
    @param_string = number_of_params_string.chop.chop
  end

  def get_values
    value_array = @fields_and_values.map { |field, value| value}
  end

  def insert(connection)
    insert_sql = "INSERT INTO #{@table_name} (#{@fields})
      VALUES (#{@param_string}) RETURNING id;"
      insert_result = connection.exec_params(insert_sql, @values)
    @id = insert_result[0]['id']
  end

  def update
    conn.exec_params(
      "UPDATE #{@table_name} SET amount = $1, application_date = $2, loan_title = $3, risk_score = $4,
      debt_to_income = $5, zip_code = $6, state = $7, employment_length = $8 WHERE id = $9;",
      [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length, @id])
  end

  def delete
    delete_sql = "DELETE FROM #{table_name} WHERE id = $1;"
    delete_results = conn.exec_params(delete_sql, [record_id])
  end

  def find
    find_sql = "SELECT * FROM #{table_name} WHERE id = $1 LIMIT 1 ;"
    result = conn.exec_params(find_sql, [id])
    return nil unless result.num_tuples == 1
    RejectedLoan.new(result[0])
  end
end
