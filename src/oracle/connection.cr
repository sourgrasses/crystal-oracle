module Oracle
  class Connection < DB::Connection
    @raw_conn : ODPI::DpiConn*
    @raw_context : ODPI::DpiContext*
    @details : String?
    getter raw_conn

    def initialize(context : DB::ConnectionContext)
      super(context)
      @raw_conn = Pointer(ODPI::DpiConn).null
      @raw_context = Pointer(ODPI::DpiContext).null

      error = ODPI::DpiErrorInfo.new

      res = ODPI.dpi_context_create(3, 3, pointerof(@raw_context), pointerof(error))

      if res != 0
        puts String.new(error.message)
      end

      user = context.uri.user.not_nil!.to_slice()
      user_len = user.size
      user = pointerof(user).as(Pointer(ODPI::UserName))

      password = context.uri.password.not_nil!.to_slice
      conn_string = context.uri.host.not_nil!.to_slice

      common_params = Pointer(ODPI::DpiCommonCreateParams).null
      create_params = Pointer(ODPI::DpiConnCreateParams).null

      res = ODPI.dpi_conn_create(@raw_context, user, user_len, password,
                                 password.size, conn_string, conn_string.size,
                                 common_params, create_params, pointerof(@raw_conn))

      if res != 0
        puts res
        raise "Error establishing connection"
      end
    end

    def build_prepared_statement(query) : Statement
      Statement.new(self, query)
    end

    def build_unprepared_statement(query) : Statement
      Statement.new(self, query)
    end

    def do_close
      res = ODPI.dpi_conn_release(@raw_conn)
      res = ODPI.dpi_context_destroy(@raw_context)
    end
  end
end
