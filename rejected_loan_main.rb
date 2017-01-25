require 'pg'
require_relative 'rejected_loan'

def main
  do_reords_exist
  if row_count.to_i == 0
    RejectedLoan.load_file
  end
end

def do_reords_exist?
  conn = PG.connect(dbname: 'search_engine_oop')
  table_name = 'reject_stats_oop'

  records = conn.exec_params("SELECT COUNT(*) FROM $1;", [table_name])
  row_count = records.getvalue 0, 0
  row_count > 0 ? true : false
end

main if __FILE__ == $PROGRAM_NAME
