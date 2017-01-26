require 'pg'
require_relative 'rejected_loan'

def main
  if not table_exist?
    RejectedLoan.create_table
  end

  if not records_exist?
    RejectedLoan.seed_database
  end

  main_menu
end

def main_menu
  puts "Lending Club 2016 Q3 Rejected Loan Database\n\n"
  puts "Enter (1) to Search, (2) to Sort, (3) to Update, and (4) to Delete"
  input_selection = gets.chomp.to_i

  case input_selection
    when 1
      RejectedLoan.get_search_input
    when 2
      RejectedLoan.get_sort_input
    when 3
      update
    when 4
      RejectedLoan.get_delete_input
    else
      RejectedLoan.get_search_input
  end
end

def table_exist?
  conn = PG.connect(dbname: 'search_engine_oop')
  table_name = conn.quote_ident('reject_stats_oop')

  begin
    records = conn.exec_params("SELECT COUNT(*) FROM #{table_name};")
  rescue PG::UndefinedTable
    return false
  ensure
    conn.close
  end
  true
end

def records_exist?
  conn = PG.connect(dbname: 'search_engine_oop')
  table_name = conn.quote_ident('reject_stats_oop')

  records = conn.exec_params("SELECT COUNT(*) FROM #{table_name};")
  conn.close
  row_count = records.getvalue 0, 0
  row_count.to_i > 0
end


main if __FILE__ == $PROGRAM_NAME
