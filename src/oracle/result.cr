module Oracle
  class Field
    @name : String
    @value : ODPI::DpiData*
    @typenum : ODPI::DpiNativeTypeNum
    @length : UInt32?

    getter name, typenum, length

    def initialize(@name, @value, @typenum, @length = nil)
    end

    def value
        if typenum == ODPI::DpiNativeTypeNum::Bytes
          slice = Slice.new(@value.value.value.asBytes.ptr,
                            @value.value.value.asBytes.length)
          String.new(slice)
        elsif typenum == ODPI::DpiNativeTypeNum::Int64
          @value.value.value.asInt64
        end
    end
  end

  class ResultSet < DB::ResultSet
    @col_index : UInt32
    @col_names : Array(String)
    @data_buffer : ODPI::DpiData*
    @error_info : ODPI::DpiErrorInfo
    @num_cols : UInt32
    @raw_context : ODPI::DpiContext*
    @raw_stmt : ODPI::DpiStmt*

    def initialize(statement : Statement, @num_cols)
      super(statement)

      @col_index = 1
      @data_buffer = Pointer(ODPI::DpiData).null
      @col_names = Array(String).new

      @raw_context = statement.connection.raw_context
      @raw_stmt = statement.raw_stmt
      @error_info = ODPI::DpiErrorInfo.new

      query_info = ODPI::DpiQueryInfo.new
      (1..@num_cols).each do |i|
        res = ODPI.dpi_stmt_get_query_info(@raw_stmt, i, pointerof(query_info))
        if res != ODPI::DPI_SUCCESS
          ODPI.dpi_context_get_error(@raw_context, pointerof(@error_info))
          error_msg = String.new(@error_info.message)
          raise "Error fetching column names: #{error_msg}"
        end

        s = Slice.new(query_info.name, query_info.nameLength)
        @col_names.push(String.new(s))
      end
    end

    protected def fetch_next_field
      res = ODPI.dpi_stmt_get_query_value(@raw_stmt, @col_index, out typenum,
                                          pointerof(@data_buffer))

      if res != ODPI::DPI_SUCCESS
        ODPI.dpi_context_get_error(@raw_context, pointerof(@error_info))
        error_msg = String.new(@error_info.message)
        raise "Error fetching column #{@col_index}: #{error_msg}"
      end

      name = @col_names[@col_index - 1]
      Field.new(name, @data_buffer, typenum)
    end

    def rows_affected : Int32
      res = ODPI.dpi_stmt_get_row_count(@raw_stmt, out rows_affected)
      if res != ODPI::DPI_SUCCESS
        ODPI.dpi_context_get_error(@raw_context, pointerof(@error_info))
        error_msg = String.new(@error_info.message)
        raise "Error fetching number of rows affected: #{error_msg}"
      end

      rows_affected
    end

    def column_count : Int32
      @num_cols
    end

    def column_name(index : Int32) : String
      @col_names[index]
    end

    def move_next : Bool
      if ODPI.dpi_stmt_fetch(@raw_stmt, out found, out index) != 0
        ODPI.dpi_context_get_error(@raw_context, pointerof(@error_info))
        error_msg = String.new(@error_info.message)
        raise "Error fetching rows: #{error_msg}"
      end

      if found != 1
        false
      else
        @col_index = 1
        true
      end
    end

    def read
      field = fetch_next_field
      @col_index += 1
      field.value
    end

    def read(t : Int32.class) : Int32
      # TODO
    end

    def read(t : Int32?.class) : Int32?
      # TODO
    end

    def read(t : Int64.class) : Int64
      # TODO
    end

    def read(t : Int64?.class) : Int64?
      # TODO
    end

    def read(t : UInt32.class) : UInt32
      # TODO
    end

    def read(t : UInt32?.class) : UInt32?
      # TODO
    end

    def read(t : UInt64.class) : UInt64
      # TODO
    end

    def read(t : UInt64?.class) : UInt64?
      # TODO
    end

    def read(t : Float32.class) : Float32
      # TODO
    end

    def read(t : Float32?.class) : Float32?
      # TODO
    end

    def read(t : Float64.class) : Float64
      # TODO
    end

    def read(type : Float64?.class) : Float64?
      # TODO
    end

    def read(t : Bool.class) : Bool
      # TODO
    end

    def read(t : Time.class, pattern : String = "%Y-%m-%d %H:%M:%S.%N") : Time
      # TODO
    end

    def read(t : String.class) : String
      # TODO
    end

    def read(type : String?.class) : String?
      # TODO
    end

    protected def do_close
      super
    end
  end
end
