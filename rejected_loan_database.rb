require_relative 'rejected_loan'
require_relative 'Database'

class RejectedLoanDatabase < Database
  def initialize
    @tables << RejectedLoanTable.new
    @tables << LoanOfficerTable.new
  end

  def create_tables
    RejectedLoanTable.create unless RejectedLoanTable.exists?
    LoanOfficerTable.create unless LoanOfficerTable.exists?
  end
end
