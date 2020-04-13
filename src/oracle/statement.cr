module Oracle
  class Statement < DB::Statement
    @raw_stmt : Void*
    @query : Bytes
    getter raw_stmt

    def initialize(connection, query : String)
      super(connection)
      @raw_stmt = Pointer(Void).null
      @query = query.bytes()
    end

    protected def perform_query(args : Enumerable) : Oracle::ResultSet
    end

    protected def perform_exec(args : Enumerable) : DB::ExecResult
      result = perform_query(args)
      result.each { }
      DB::ExecResult.new(rows_affected: result.rows_affected, last_insert_id: 0_i64)
    end

    protected def do_cloe
      super

      ODPI.dpi_stmt_release(@raw_stmt)
    end
  end
end
