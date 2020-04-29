module Oracle
  class Binder
    @cur_var : ODPI::DpiVar*
    @cur_data : ODPI::DpiData*
    @vars : Array(ODPI::DpiVar*)

    def initialize
      @cur_var = Pointer(ODPI::DpiVar).null
      @cur_data = Pointer(ODPI::DpiData).null
      @vars = Array(ODPI::DpiVar*).new
    end

    def bind_args(stmt : Statement, args : Enumerable)
      args.each_with_index do |arg, i|
        new_var(stmt.connection, arg)

        res = ODPI.dpi_stmt_bind_by_pos(stmt.raw_stmt, i + 1, @cur_var)
        if res != ODPI::DPI_SUCCESS
          error_info = ODPI::DpiErrorInfo.new
          ODPI.dpi_context_get_error(stmt.connection.raw_context,
                                     pointerof(error_info))
          error_msg = String.new(error_info.message)
          raise "Error binding arguments by position: #{error_msg}"
        end
      end

      puts @vars
    end

    private def new_var(conn : Connection, arg)
      # TODO: deal with lob cases, varchar vs nvarchar, more careful checking
      # around number width, and arrays
      oracle_type = 
        if arg.nil?
          ODPI::DpiOracleTypeNum::None
        else
          Type.as_oracle_type_num(typeof(arg))
        end

      native_type = Type.as_native_type_num(typeof(arg))

      max_array_size = 1

      # value is only used if the vairable is to be transferred as byte string
      # TODO other byte string types
      size, size_is_bytes = 
        if arg.is_a?(String)
          {arg.bytesize, 1}
        else
          {0, 0}
        end

      res = ODPI.dpi_conn_new_var(conn.raw_conn, oracle_type, native_type,
                                  max_array_size, size, size_is_bytes, 0,
                                  Pointer(ODPI::DpiObjectType).null,
                                  out @cur_var, out @cur_data)

      if res != ODPI::DPI_SUCCESS
        error_info = ODPI::DpiErrorInfo.new
        ODPI.dpi_context_get_error(conn.raw_context, pointerof(error_info))
        error_msg = String.new(error_info.message)
        raise "Error creating new var: #{error_msg}"
      else
        set_dpi_data_value(typeof(arg), @cur_data, arg)
      end

      @vars << @cur_var
    end

    private def set_dpi_data_value(t : Int32.class, buffer : ODPI::DpiData*, arg)
      set_dpi_data_value(Int64, buffer, arg)
    end

    private def set_dpi_data_value(t : Int64.class, buffer : ODPI::DpiData*, arg)
      buffer.value.isNull = 0
      buffer.value.value.asInt64 = arg
    end

    private def set_dpi_data_value(t : UInt32.class, buffer : ODPI::DpiData*, arg)
      set_dpi_data_value(UInt64, buffer, arg)
    end

    private def set_dpi_data_value(t : UInt64.class, buffer : ODPI::DpiData*, arg)
      buffer.value.isNull = 0
      buffer.value.value.asUint64 = arg
    end

    private def set_dpi_data_value(t : Float32.class, buffer : ODPI::DpiData*, arg)
      buffer.value.isNull = 0
      buffer.value.value.asFloat = arg
    end

    private def set_dpi_data_value(t : Float64.class, buffer : ODPI::DpiData*, arg)
      buffer.value.isNull = 0
      buffer.value.value.asDouble = arg
    end

    private def set_dpi_data_value(t : Bool.class, buffer : ODPI::DpiData*, arg)
      buffer.value.isNull = 0
      if arg
        buffer.value.value.asBoolean = 1
      else
        buffer.value.value.asBoolean = 0
      end
    end

    private def set_dpi_data_value(t : Time.class, buffer : ODPI::DpiData*, arg)
      # TODO
    end

    private def set_dpi_data_value(t : String.class, buffer : ODPI::DpiData*, arg)
      buffer.value.isNull = 0

      bytes = ODPI::DpiBytes.new
      # unsafe
      bytes.ptr = arg.to_unsafe
      bytes.length = arg.size

      buffer.value.value.asBytes = bytes
    end
  end
end
