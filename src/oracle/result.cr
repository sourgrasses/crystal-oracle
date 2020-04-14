module Oracle
  class ResultSet < DB::ResultSet
    @rows_affected : UInt32
    @buffer : Array(UInt8*)
    @strlen : Array(Int64)

    def initialize(statement : Statement, @num_cols : UInt32)
      super(statement)

      raw_context = statement.connection.raw_context
      res = ODPI.dpi_stmt_fetch_rows(statement.raw_stmt, UInt32::MAX,
                                     out row_index, out @rows_affected,
                                     out more_rows)

      if res != 0
        ODPI.dpi_context_get_error(raw_context, out error)
        error_msg = String.new(error.message)
        raise "Error fetching number of rows affected: #{error_msg}"
      end

      # TODO
      @buffer = Array(UInt8*).new
      @strlen = Array(Int64).new
    end

    def column_count : Int32
    end

    def column_name(index : Int32) : String
    end

    def move_next : Bool
      false
    end
  end
end
