require_relative 'table'

class LoanOfficerTable < Table
  attr_reader :name

  def initialize(table_options)
    @name = table_options['name']
    @connection = table_options['connection']
  end
end
