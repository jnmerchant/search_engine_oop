require 'pg'
require_relative 'database'
require_relative 'rejected_loan_database'
require_relative 'rejected_loan_menu'

class DataBaseDoesNotExist < StandardError
end

def main
  db_options = {'name' => 'search_engine_oop'} # Hard Coded database, variable??
  rejected_loan_database = RejectedLoanDatabase.new(db_options)

  if rejected_loan_database.exists?
    rejected_loan_database.create_tables
  else
    raise DataBaseDoesNotExist, "The database referenced does not exits."
  end

  # if not RejectedLoanDatabase.records_exist?
  #   RejectedLoanDatabase.seed
  # end
  #
  # RejectedLoanMenu.display_main_menu
end

main if __FILE__ == $PROGRAM_NAME
