module Oracle
  class ResultSet < DB::ResultSet
    @num_cols : Int32
    @rows_affected : Int64
    @buffer : Array(UInt8*)
    @strlen : Array(Int64)

    def initialize(statement)
      super(statement)
      # TODO
      @num_cols = 0
      @rows_affected = 0
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
