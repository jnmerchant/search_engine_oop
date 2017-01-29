def table_structures(name)
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
