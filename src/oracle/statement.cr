module Oracle
  class Statement < DB::Statement
    @raw_stmt : ODPI::DpiStmt*
    @query : Bytes
    getter raw_stmt

    def initialize(connection, query : String)
      super(connection)
      @raw_stmt = Pointer(ODPI::DpiStmt).null
      @query = query.to_slice()
    end

    protected def raw_conn
      @connection.as(Connection).raw_conn
    end

    protected def perform_query(args : Enumerable) : Oracle::ResultSet
      null = Pointer(Void).null
      conn = raw_conn()
      res = ODPI.dpi_conn_prepare_stmt(conn, 0, @query, @query.size,
                                       Pointer(UInt8).null, 0,
                                       pointerof(@raw_stmt))

      if res != 0
        raise "Error preparing statement"
      end

      num_cols = Pointer(UInt32).null
      res = ODPI.dpi_stmt_execute(@raw_stmt , ODPI::DpiExecMode::Default, num_cols)

      if res != 0
        raise "Error executing statement"
      end

      ResultSet.new(self)
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
