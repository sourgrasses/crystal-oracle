module Oracle
  module Type
    extend self

    def as_oracle_type_num(t : Int32.class)
      ODPI::DpiOracleTypeNum::Number
    end

    def as_oracle_type_num(t : Int64.class)
      ODPI::DpiOracleTypeNum::Number
    end

    def as_oracle_type_num(t : UInt32.class)
      ODPI::DpiOracleTypeNum::Number
    end

    def as_oracle_type_num(t : UInt64.class)
      ODPI::DpiOracleTypeNum::Number
    end

    def as_oracle_type_num(t : Float32.class)
      ODPI::DpiOracleTypeNum::Number
    end

    def as_oracle_type_num(t : Float64.class)
      ODPI::DpiOracleTypeNum::Number
    end

    def as_oracle_type_num(t : Bool.class)
      ODPI::DpiOracleTypeNum::Boolean
    end

    def as_oracle_type_num(t : Time.class, pattern : String = "%Y-%m-%d %H:%M:%S.%N")
      # TODO
      ODPI::DpiOracleTypeNum::Date
    end

    def as_oracle_type_num(t : String.class)
      ODPI::DpiOracleTypeNum::Nvarchar
    end

    def as_native_type_num(t : Int32.class)
      ODPI::DpiNativeTypeNum::Int64
    end

    def as_native_type_num(t : Int64.class)
      ODPI::DpiNativeTypeNum::Int64
    end

    def as_native_type_num(t : UInt32.class)
      ODPI::DpiNativeTypeNum::Uint64
    end

    def as_native_type_num(t : UInt64.class)
      ODPI::DpiNativeTypeNum::Uint64
    end

    def as_native_type_num(t : Float32.class)
      ODPI::DpiNativeTypeNum::Float
    end

    def as_native_type_num(t : Float64.class)
      ODPI::DpiNativeTypeNum::Double
    end

    def as_native_type_num(t : Bool.class)
      ODPI::DpiNativeTypeNum::Boolean
    end

    def as_native_type_num(t : Time.class, pattern : String = "%Y-%m-%d %H:%M:%S.%N")
      ODPI::DpiNativeTypeNum::Timestamp
    end

    def as_native_type_num(t : String.class)
      ODPI::DpiNativeTypeNum::Bytes
    end

    def string_as_dpi_bytes(s : String) : ODPI::DpiBytes
      s.check_no_null_byte

      bytes = ODPI::DpiBytes.new
      bytes.ptr = s.to_unsafe
      bytes.length = s.size

      bytes
    end
  end
end
