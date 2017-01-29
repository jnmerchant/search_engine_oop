require 'pg'
require_relative 'row'

class LoanOfficer < Row
  attr_reader :id, :table_name
  attr_accessor :first_name, :last_name, :title, :years_of_experience

  def initialize(row_options)
    @id = row_options['id']
    @first_name = row_options['first_name']
    @last_name = row_options['last_name']
    @title = row_options['title']
    @years_of_experience = options[:years_of_experience]
    @formatted_options = {'id' => @id, 'first_name' => @first_name, 'last_name' => @last_name,
      'title' => @title, 'years_of_experience' => @years_of_experience}
    @table_name = ''
  end

end
