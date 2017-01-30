require_relative 'table'

class RejectedLoanTable < Table
  attr_reader :name

  def initialize(table_options)
    @name = table_options['name']
    @connection = table_options['connection']
  end

  # TODO: SQL get stuff belongs in table, print stuff maybe not
  def self.get_field_values(field_name)
    db_values = []
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    field_name = conn.quote_ident(field_name)
    db_values = conn.exec("SELECT DISTINCT #{field_name} FROM #{table_name};")
    conn.close
    values = db_values.values.join(" ") # TODO: pull in to a display_field_values?
    p values.gsub ' ', " | "
  end

  # TODO: SQL get stuff belongs in table, print stuff maybe not
  def self.display_db_fields
    db_fields = [] # TODO: pull in to a get_db_fields... maybe name this get_table_fields?
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    db_fields = conn.exec("SELECT * FROM #{table_name} WHERE id=0;")
    conn.close
    columns = db_fields.fields.join(" ") # TODO: pull in to a display_table_fields
    p columns.gsub ' ', " | "
  end

  # TODO: decide where this belongs.... think about it, ask again later when it's all cleaned up
  def self.output_results(results) # TODO: maybe have a convention for output function names, display or output or etc? pick one and stick with it
    format = "%-10s\t%-15s\t%-10s\t%-20s\t%-10s\t%-20s\t%-10s\n"
    printf(format, "ID", "Amount", "Debt to Income", "Loan Title", "Risk Score", "Employment Length", "State\n")
    results.each do |result|
      printf(format, "#{result['id']}", "$""#{result['amount']}", "#{result['debt_to_income']}",
      "#{result['loan_title']}", "#{result['risk_score']}", "#{result['employment_length']}", "#{result['state']}")
    end
  end
end
