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
    @data_buffer : Pointer(ODPI::DpiData)
    @names : Array(String)
    @num_cols : UInt32
    @rows_affected : UInt64

    def initialize(statement : Statement, @num_cols)
      super(statement)

      @data_buffer = Pointer(ODPI::DpiData).null
      @names = Array(String).new

      raw_context = statement.connection.raw_context
      error = ODPI::DpiErrorInfo.new

      if ODPI.dpi_stmt_get_row_count(statement.raw_stmt, out @rows_affected) != 0
        ODPI.dpi_context_get_error(raw_context, pointerof(error))
        error_msg = String.new(error.message)
        raise "Error fetching number of rows affected: #{error_msg}"
      end

      query_info = ODPI::DpiQueryInfo.new
      (1..@num_cols).each do |i|
        if ODPI.dpi_stmt_get_query_info(statement.raw_stmt, i, pointerof(query_info)) != 0
          ODPI.dpi_context_get_error(raw_context, pointerof(error))
          error_msg = String.new(error.message)
          raise "Error fetching column names: #{error_msg}"
        end

        s = Slice.new(query_info.name, query_info.nameLength)
        @names.push(String.new(s))
      end

      if ODPI.dpi_stmt_fetch(statement.raw_stmt, out found, out index) != 0
        ODPI.dpi_context_get_error(raw_context, pointerof(error))
        error_msg = String.new(error.message)
        raise "Error fetching rows: #{error_msg}"
      end

      if found != 1
        return
      end

      (1..@num_cols).each do |i|
        res = ODPI.dpi_stmt_get_query_value(statement.raw_stmt, i,
                                            out typenum, pointerof(@data_buffer))

        if res != 0
          ODPI.dpi_context_get_error(raw_context, pointerof(error))
          error_msg = String.new(error.message)
          raise "Error fetching column #{i}: #{error_msg}"
        end

        field = Field.new("", @data_buffer, typenum)
        puts field.value
      end
    end

    def column_count : Int32
      @num_cols
    end

    def column_name(index : Int32) : String
      @names[index]
    end

    def move_next : Bool
      false
    end

    def read
      value = @buffer[@col_index]
      @col_index += 1
      value
    end

    def read(t : Int32.class) : Int32
      self.read(String).to_i32
    end

    def read(t : Int32?.class) : Int32?
      read(String).to_i32?
    end

    def read(t : Int64.class) : Int64
      self.read(String).to_i64
    end

    def read(t : Int64?.class) : Int64?
      read(String).to_i64?
    end

    def read(t : UInt32.class) : UInt32
      self.read(String).to_u32
    end

    def read(t : UInt32?.class) : UInt32?
      read(String).to_u32?
    end

    def read(t : UInt64.class) : UInt64
      self.read(String).to_u64
    end

    def read(t : UInt64?.class) : UInt64?
      read(String).to_u64?
    end

    def read(t : Float32.class) : Float32
      self.read(String).to_f32
    end

    def read(t : Float32?.class) : Float32?
      read(String).to_f32?
    end

    def read(t : Float64.class) : Float64
      self.read(String).to_f64
    end

    def read(type : Float64?.class) : Float64?
      read(String).to_f64?
    end

    def read(t : Bool.class) : Bool
      self.read(String) == "1"
    end

    def read(t : Time.class, pattern : String = "%Y-%m-%d %H:%M:%S.%N") : Time
      Time.parse_local(self.read(String), pattern)
    end

    def read(t : String.class) : String
      String.new(self.read)
    end

    def read(type : String?.class) : String?
      self.read.try &.to_s
    end

    protected def do_close
      super
    end
  end
end
