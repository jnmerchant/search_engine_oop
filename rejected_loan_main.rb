require 'pg'
require_relative 'database'
require_relative 'rejected_loan_database'
require_relative 'rejected_loan_menu'

def main
  options = {'name' => 'search_engine_oop', 'connection' => "PG.connect(dbname: 'search_engine_oop')"}
  rl_database = RejectedLoanDatabase.new(options)
  p rl_database


  if not rl_database.exists?
    rl_database.create_table
  end

  if not RejectedLoanDatabase.records_exist?
    RejectedLoanDatabase.seed
  end

  RejectedLoanMenu.display_main_menu
end

main if __FILE__ == $PROGRAM_NAME
