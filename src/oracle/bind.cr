module Oracle
  class Binder
    @cur_var : ODPI::DpiVar*
    @cur_data : ODPI::DpiData*
    @vars : ODPI::DpiVar*?

    def initialize
      @cur_var = Pointer(ODPI::DpiVar).null
      @cur_data = Pointer(ODPI::DpiData).null
    end

    def bind_args(conn : ODPI::DpiConn*, stmt : ODPI::DpiStmt*, args : Enumerable)
      args.each_with_index do |arg, i|
        puts "arg #{i + 1}: #{arg}"

        new_var(conn, arg)

        if ODPI.dpi_stmt_bind_by_pos(stmt, i + 1, @cur_var) != ODPI::DPI_SUCCESS
          raise "Error binding arguments by position"
        end
      end
    end

    private def new_var(conn : ODPI::DpiConn*, arg)
      # TODO: deal with lob cases, varchar vs nvarchar, more careful checking
      # around number width
      oracle_type = 
        if arg.nil?
          ODPI::DpiOracleTypeNum::None
        else
          Type.as_oracle_type_num(typeof(arg))
        end

      native_type = Type.as_native_type_num(typeof(arg))

      puts "oracle type: #{oracle_type}, native type : #{native_type}"

      res = ODPI.dpi_conn_new_var(conn, oracle_type, native_type, 0, 0, 0, 0,
                                  Pointer(ODPI::DpiObjectType).null,
                                  out @cur_var, out @cur_data)

      if res != ODPI::DPI_SUCCESS
        raise "Error binding variable by position"
      end
    end
  end
end
