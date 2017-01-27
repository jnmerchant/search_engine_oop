require_relative 'rejected_loan'
require_relative 'Database'

class RejectedLoanDatabase < Database
  def initialize
    @tables << RejectedLoanTable.new
    @tables << LoanOfficerTable.new
  end

  #TODO: make this real, leave it here in Database
  def create_tables
    RejectedLoanTable.create unless RejectedLoanTable.exists?
    LoanOfficerTable.create unless LoanOfficerTable.exists?
  end

  def exists?
    # TODO: ... maybe... we could share conn across many operations? I would do this one last.
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    schema_name = conn.quote_ident('public')

    result = conn.exec_params("SELECT EXISTS (
      SELECT 1 FROM pg_tables
      WHERE schemaname = #{schema_name}
      AND tablename = #{table_name});")
    conn.close
    result[0] ? true : false
  end


end
