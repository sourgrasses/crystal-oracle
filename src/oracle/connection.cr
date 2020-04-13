module Oracle
  class Connection < DB::Connection
    @details : String?
    getter raw_conn

    def initialize(context : DB::ConnectionContext)
      super(context)
    end

    def build_prepared_statement(query) : Statement
      Statement.new(self, query)
    end

    def build_unprepared_statement(query) : Statement
      Statemen.new(self, query)
    end

    def do_close
    end
  end
end
