class Database
  def initialize(tables)
    @tables = tables
  end

  def create_tables
    @tables.each { |table| table.create }
  end

  def drop_tables
    @tables.each { |table| table.drop }
  end

  def seed
    @tables.each { |table| table.seed }
  end

  def table_exists?
    # TODO: ... maybe... we could share conn across many operations? I would do this one last.
    conn = PG.connect(dbname: 'search_engine_oop')
    table_name = conn.quote_ident('reject_stats_oop')
    schema_name = conn.quote_ident('public')

    result = conn.exec_params("SELECT EXISTS (
      SELECT 1 FROM pg_tables
      WHERE schemaname = #{schema_name}
      AND tablename = #{table_name});")
    conn.close
    result[0] ? true : false
  end
end
