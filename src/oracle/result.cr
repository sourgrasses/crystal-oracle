module Oracle
  class ResultSet < DB::ResultSet
    @rows_affected : UInt64
    @buffer : Array(UInt8*)
    @strlen : Array(Int64)

    def initialize(statement : Statement, @num_cols : UInt32)
      super(statement)

      raw_context = statement.connection.raw_context
      error = ODPI::DpiErrorInfo.new

      if ODPI.dpi_stmt_get_row_count(statement.raw_stmt, out @rows_affected) != 0
        ODPI.dpi_context_get_error(raw_context, pointerof(error))
        error_msg = String.new(error.message)
        raise "Error fetching number of rows affected: #{error_msg}"
      end

      loop do
        if ODPI.dpi_stmt_fetch(statement.raw_stmt, out found, out index) != 0
          ODPI.dpi_context_get_error(raw_context, pointerof(error))
          error_msg = String.new(error.message)
          raise "Error fetching rows: #{error_msg}"
        end

        if found != 1
          break
        end

        (1..@num_cols).each do |i|
          if ODPI.dpi_stmt_get_query_value(statement.raw_stmt, i, out typenum, out data) != 0
            ODPI.dpi_context_get_error(raw_context, pointerof(error))
            error_msg = String.new(error.message)
            raise "Error fetching column #{i}: #{error_msg}"
          end

          puts data.value
        end
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
