require_relative 'rejected_loan_database'

class RejectedLoanMenu
  def initialize
  end

  def self.display_main_menu
    puts "\n"
    puts "Lending Club 2016 Q3 Rejected Loan Database\n"

    quit = ''
    until quit == 'q'
      puts "Enter (1) - to Search, (2) - to Sort, (3) - to Update, (4) - to Delete and (5) - to Add"
      input_selection = gets.chomp.to_i
      case input_selection
        when 1
          RejectedLoanDatabase.get_search_input
        when 2
          RejectedLoanDatabase.get_sort_input
        when 3
          RejectedLoanDatabase.get_update_input
        when 4
          RejectedLoanDatabase.get_delete_input
        when 5
          RejectedLoanDatabase.get_add_input
        else
          puts 'Search default selected.'
          RejectedLoanDatabase.get_search_input
      end
      puts 'Enter Q to quit or enter to continue: '
      quit = gets.chomp.downcase
    end
  end
end
