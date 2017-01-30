require 'pg'
require_relative 'table'
require_relative 'database'
require_relative 'rejected_loan_table'
require_relative 'loan_officer_table'

class RejectedLoanDatabase < Database
  attr_reader :name, :connection, :tables

  def initialize(db_options)
    @name = db_options['name']
    @connection = PG.connect(dbname: "#{@name}")
    @tables = []
    @table_options = {'name' => 'loan_officers', 'connection' => @connection} # Hard Coded table name, variable??
    loan_officer_table = LoanOfficerTable.new(@table_options)
    @tables << loan_officer_table
    @table_options = {}
    @table_options = {'name' => 'reject_loans', 'connection' => @connection} # Hard Coded table name, variable??
    rejected_loan_table = RejectedLoanTable.new(@table_options)
    @tables << rejected_loan_table
  end

end
