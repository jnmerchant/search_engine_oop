require_relative 'table'
require_relative 'database'

class RejectedLoanDatabase < Database
  def initialize(options)
    @name = options['name']
    @tables = {}
    @connection = options['connection']

    # rl_table = RejectedLoanTable.new({'name' => 'reject_stats_oop'})
    # @tables[] rl_table
    # @tables << LoanOfficerTable.new
  end

  def create_tables
    # RejectedLoanTable.create unless RejectedLoanTable.exists?
    # LoanOfficerTable.create unless LoanOfficerTable.exists?
  end
end
