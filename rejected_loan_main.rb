require 'pg'
require_relative 'rejected_loan'
require_relative 'rejected_loan_database'
require_relative 'rejected_loan_menu'

def main
  if not RejectedLoanDatabase.table_exists?
    RejectedLoanDatabase.create_table
  end

  if not RejectedLoanDatabase.records_exist?
    RejectedLoanDatabase.seed
  end

  RejectedLoanMenu.display_main_menu
end

main if __FILE__ == $PROGRAM_NAME
