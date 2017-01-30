require_relative 'rejected_loan_database'
require_relative 'rejected_loan'

class RejectedLoanMenu
  def initialize
  end

  def display_main_menu
    puts "\n"
    puts "Lending Club 2016 Q3 Rejected Loan Database\n"

    quit = ''
    until quit == 'q'
      puts "Enter (1) - to Search, (2) - to Sort, (3) - to Update, (4) - to Delete and (5) - to Add"
      input_selection = gets.chomp.to_i
      case input_selection
        when 1
          get_search_input
        when 2
          get_sort_input
        when 3
          RejectedLoanDatabase.get_update_input
        when 4
          RejectedLoanDatabase.get_delete_input
        when 5
          get_add_input
        else
          puts 'Search default selected.'
          RejectedLoanDatabase.get_search_input
      end
      puts 'Enter Q to quit or enter to continue: '
      quit = gets.chomp.downcase
    end
  end

  def get_add_input
    options = {}
    puts "Please enter the details of the rejected loan."
    puts "Amount of the rejected loan: (00.00)"
    amount = gets.chomp.to_f
    puts "Application date: (YYYY-MM_DD)"
    application_date = gets.chomp
    puts "Loan title: (text)"
    loan_title = gets.chomp
    puts "Risk score: (0)"
    risk_score = gets.chomp.to_i
    puts "Debt to income: (0.0)"
    debt_to_income = gets.chomp.to_f
    puts "Zip code: (text)"
    zip_code = gets.chomp
    puts "State: (ST)"
    state = gets.chomp.upcase
    puts "Employment length: (text)"
    employment_length = gets.chomp

    options = {'amount' => amount, 'application_date' => application_date, 'loan_title' => loan_title, 'risk_score' => risk_score,
    'debt_to_income' => debt_to_income, 'zip_code' => zip_code, 'state' => state, 'employment_length' => employment_length}

    rejected_loan = RejectedLoan.new(options)
    rejected_loan.save
  end

  def get_sort_input
    puts "Please enter a column name from the list below for a sorted table: "
    display_db_fields
    sort_field = gets.chomp.downcase
    puts "Please enter ASC or DESC sort order: "
    sort_order = gets.chomp.upcase
    sort_database(sort_field, sort_order) # TODO: maybe/probably doesn't belong here
  end

  def get_delete_input
    puts "Please enter a columnn name to filter and locate record to delete: "
    display_db_fields
    field_name = gets.chomp.downcase
    puts "Enter a value from the list below to search: "
    get_field_values(field_name)
    search_value = gets.chomp
    search_database(field_name, search_value)
    puts "Enter the record id you would like to delete: "
    id_to_delete = gets.chomp.to_i
    delete_record(id_to_delete, field_name, search_value) # TODO: maybe this as well
  end

  def get_search_input
    puts "Please enter a columnn name from the list below to search: "
    display_db_fields
    field_name = gets.chomp.downcase
    puts "Enter a value from the list below to search: "
    get_field_values(field_name)
    search_value = gets.chomp
    search_database(field_name, search_value) # TODO: maybe not here
  end
end
