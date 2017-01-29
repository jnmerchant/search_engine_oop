require 'pg'
require_relative 'row'

class InvalidRejectedLoan < StandardError
end

class RejectedLoan < Row
  attr_reader :id, :table_name
  attr_accessor :amount, :application_date, :loan_title, :risk_score, :debt_to_income,
    :zip_code, :state, :employment_length

  def initialize(row_options)
    @id = row_options['id']
    @amount = row_options['amount'].to_f
    @application_date = row_options['application_date']
    @loan_title = row_options['loan_title']
    @risk_score = row_options['risk_score'].to_i
    @debt_to_income = /[\d+\.]/.match(row_options['debt_to_income'])
    @zip_code = /[A-Z]{2}/.match(row_options['zip_code'])
    @state = row_options['state']
    @employment_length = row_options['employment_length']
    @formatted_options = {'id' => @id, 'amount' => @amount, 'application_date' => @application_date,
      'loan_title' => @loan_title, 'risk_score' => @risk_score, 'debt_to_income' => @debt_to_income,
      'zip_code' => @zip_code, 'state' => @state, 'employment_length' => @employment_length}
    @table_name = ''
  end

  def save
    conn = PG.connect(dbname: 'search_engine_oop')
    has_id? ? udpate_row : create_row
    conn.close
  end

  def is_valid?
    @amount > 0 and # TODO: finish validation
    not @application_date.nil? and not @application_date.empty?
  end

  def validate
    raise InvalidRejectedLoan unless is_valid?
  end

  def has_id?
    not @id.nil?
  end

  def insert_row
    RejectedLoan.new(@formatted_options).insert
  end

  def update_row
    RejectedLoan.new(@formatted_options).update
  end
end
