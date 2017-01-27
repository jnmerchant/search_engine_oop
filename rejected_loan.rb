require 'csv'
require 'pg'
require_relative 'row'

class InvalidRejectedLoan < StandardError
end

class RejectedLoan < Row
  attr_reader :id
  attr_accessor :amount, :application_date, :loan_title, :risk_score, :debt_to_income,
    :zip_code, :state, :employment_length

  def initialize(options)
    @id = options['id']
    @amount = options['amount'].to_f
    @application_date = options['application_date']
    @loan_title = options['loan_title']
    @risk_score = options['risk_score'].to_i
    @debt_to_income = /[\d+\.]/.match(options['debt_to_income'])
    @zip_code = options['zip_code']
    @state = options['state']
    @employment_length = options['employment_length']
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

  def create_row
    RejectedLoan.new(options).insert
    # table_name = conn.quote_ident('reject_stats_oop')
    # result = conn.exec_params(
    #   "INSERT INTO #{table_name} (amount, application_date, loan_title, risk_score,
    #   debt_to_income, zip_code, state, employment_length) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id;",
    #   [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length])
    #
    # @id = result[0]['id']
  end

  def update_row
    RejectedLoan.new(options).update
  #   table_name = conn.quote_ident('reject_stats_oop')
  #   conn.exec_params(
  #     "UPDATE #{table_name} SET amount = $1, application_date = $2, loan_title = $3, risk_score = $4,
  #     debt_to_income = $5, zip_code = $6, state = $7, employment_length = $8 WHERE id = $9;",
  #     [@amount, @application_date, @loan_title, @risk_score, @debt_to_income, @zip_code, @state, @employment_length, @id])
  # end
end
