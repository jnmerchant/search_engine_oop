
class MissingTableName < StandardError
end

def get_table_structures(name)
  if name == 'reject_loans'
    fields = {'id' => 'serial primary key', 'amount' => 'numeric',
      'application_date' => 'date', 'loan_title' => 'varchar',
      'risk_score' => 'integer', 'debt_to_income' => 'numeric',
      'zip_code' => 'varchar', 'state' => 'varchar',
      'employment_length' => 'varchar', 'loan_officer_id' => 'integer REFERENCES loan_officers (id)'}
  elsif name == 'loan_officers'
    fields = {'id' => 'serial primary key', 'first_name' => 'varchar',
      'last_name' => 'varchar', 'title' => 'varchar',
      'years_of_experience' => 'integer'}
  else
    raise MissingTableStructureDefinition, "There is no table structure defined for #{name}."
  end
end

def get_file_paths(name)
  if name == 'reject_loans'
    path = '/Users/Joe/Documents/TIY/Week3/search_engine_oop/data/q3_reject_stats.csv'
  elsif name == 'loan_officers'
    path = '/Users/Joe/Documents/TIY/Week3/search_engine_oop/data/loan_officers.csv'
  else
    #error
  end
end

def process_csv_row(name, row)
  if name == 'reject_loans'
    processed_row = []
    processed_row << row[0] # amount
    processed_row << row[1] # application_date
    processed_row << row[2] # loan_title
    processed_row << row[3] # risk_score
    processed_row << row[4] # debt_to_income
    processed_row << row[5] # zip_code
    processed_row << row[6] # state
    processed_row << row[7] # employment_length
    processed_row << row[8] # loan officer id
    processed_row
  elsif name == 'loan_officers'
    processed_row = []
    processed_row << row[0] # first_name
    processed_row << row[1] # last_name
    processed_row << row[2] # title
    processed_row << row[3] # years_of_experience
    processed_row
  else
    raise MissingTableName, "The table name used is not a valid table name in the database."
  end
end

# def get_fields(name)
#   field_hash = get_table_structures(name)
#   field_hash.delete_if {|key, value| key == 'id' }
#   field_hash.keys
# end

def get_csv_object(name)
  if name == 'reject_loans'
    'RejectedLoan.new(options)'
  elsif name == 'loan_officers'
    'LoanOfficer.new(options)'
  else
    raise MissingTableName, "The table name used is not a valid table name in the database."
  end
end
