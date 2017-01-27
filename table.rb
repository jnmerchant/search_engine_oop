class Table

  # TODO: refactor in to Table
  def records_exist?
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    records = conn.exec_params("SELECT COUNT(*) FROM #{table_name};")
    conn.close
    row_count = records.getvalue 0, 0
    row_count.to_i > 0
  end
end
